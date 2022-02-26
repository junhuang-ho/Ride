import pytest
import brownie
import scripts.utils as utils

chain = brownie.network.state.Chain()


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


###########################################
##### ------------------------------- #####
##### ----- driver registration ----- #####
##### ------------------------------- #####
###########################################


def test_driver_registration_succeed(
    ride_badge, ride_driver_registry, deployer, person1
):

    assert ride_badge.getDriverToDriverReputation(person1)[0] == 0
    assert ride_badge.getDriverToDriverReputation(person1)[1] == ""
    assert ride_badge.getDriverToDriverReputation(person1)[2] == 0

    # 1 # --> applicant submits application
    uri = "test docs"

    # 2 # --> admin approves application
    tx = ride_driver_registry.approveApplicant(person1, uri, {"from": deployer})
    tx.wait(1)

    # 3 # --> driver completes registration after approval
    max_metres_per_trip = 888
    tx = ride_driver_registry.registerAsDriver(max_metres_per_trip, {"from": person1})
    tx.wait(1)

    assert ride_badge.getDriverToDriverReputation(person1)[0] == 1
    assert ride_badge.getDriverToDriverReputation(person1)[1] == uri
    assert ride_badge.getDriverToDriverReputation(person1)[2] == max_metres_per_trip


def test_driver_registration_rejected(ride_driver_registry, person1):

    # 1 # --> registration is rejected if application not approved
    with brownie.reverts("RideDriverRegistry: URI not set in background check"):
        ride_driver_registry.registerAsDriver(888, {"from": person1})


###########################################
##### ------------------------------- #####
##### ----------- deposit ----------- #####
##### ------------------------------- #####
###########################################


def deposit(ride_hub, ride_currency_registry, ride_holding, ride_WETH9, person):
    amount = "10 ether"

    # 1 # --> convert ETH to wETH by sending ether to wETH contract (unique to this wETH contract)
    assert ride_WETH9.balanceOf(person) == 0

    tx = person.transfer(ride_WETH9.address, amount)
    tx.wait(1)

    assert ride_WETH9.balanceOf(person) == amount

    # 2 # --> approve RideHub contract to be able to handle user's wETH
    # NOTE: if in token contract, increaseAllowance/decreaseAllowance is available instead, use it!!
    # otherwise use approve, but keep best practice: https://ethereum.org/en/developers/tutorials/erc20-annotated-code/#allowance-functions
    assert ride_WETH9.allowance(person, ride_hub[0].address) == 0

    tx = ride_WETH9.approve(ride_hub[0].address, amount, {"from": person})
    tx.wait(1)

    assert ride_WETH9.allowance(person, ride_hub[0].address) == amount

    # 3 # --> user deposit wETH from wallet to RideHub contract
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)

    assert ride_holding.getHolding(person, key_wETH) == 0

    tx = ride_holding.depositTokens(key_wETH, amount, {"from": person})
    tx.wait(1)

    assert ride_holding.getHolding(person, key_wETH) == amount

    return key_wETH


def test_deposit(ride_hub, ride_currency_registry, ride_holding, ride_WETH9, person1):
    deposit(ride_hub, ride_currency_registry, ride_holding, ride_WETH9, person1)


###########################################
##### ------------------------------- #####
##### ------ main interactions ------ #####
##### ------------------------------- #####
###########################################


def _setup(
    ride_hub,
    ride_currency_registry,
    ride_holding,
    ride_badge,
    ride_driver_registry,
    ride_ticket,
    ride_WETH9,
    deployer,
    person1,
    person2,
):
    test_driver_registration_succeed(
        ride_badge, ride_driver_registry, deployer, person1
    )
    key_wETH = deposit(
        ride_hub, ride_currency_registry, ride_holding, ride_WETH9, person1
    )
    key_wETH = deposit(
        ride_hub, ride_currency_registry, ride_holding, ride_WETH9, person2
    )

    assert ride_badge.getDriverToDriverReputation(person1)[0] != 0  # driver
    assert ride_badge.getDriverToDriverReputation(person2)[0] == 0  # passenger

    assert ride_holding.getHolding(person1, key_wETH) > 0
    assert ride_holding.getHolding(person1, key_wETH) == ride_holding.getHolding(
        person2, key_wETH
    )

    assert ride_ticket.getUserToTixId(person1) == utils.ZERO_BYTES32  # not active
    assert ride_ticket.getUserToTixId(person2) == utils.ZERO_BYTES32  # not active

    key_USD = ride_currency_registry.getKeyFiat("USD")

    return key_USD, key_wETH


def test_drv_indicate_dst_reached_pax_agrees(
    ride_hub,
    ride_currency_registry,
    ride_holding,
    ride_badge,
    ride_driver_registry,
    ride_ticket,
    ride_passenger,
    ride_driver,
    ride_WETH9,
    deployer,
    person1,
    person2,
):
    # 1 # --> setup
    key_USD, key_wETH = _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_badge,
        ride_driver_registry,
        ride_ticket,
        ride_WETH9,
        deployer,
        person1,
        person2,
    )

    # 2 # --> passenger request ticket
    badge_requested = 0
    strict = False
    estimated_minutes = 2
    estimated_metres = 100

    tx = ride_passenger.requestTicket(
        key_USD,
        key_wETH,
        badge_requested,
        strict,
        estimated_minutes,
        estimated_metres,
        {"from": person2},
    )
    tx.wait(1)

    # # 3 # --> get ticket to display to driver
    # assert tx.events["RequestTicket"]["sender"] == person2
    # assert ride_ticket.getUserToTixId(person2) == ticket_id # passenger active
    # ticket_id = tx.events["RequestTicket"]["tixId"]
    # trip_fare = tx.events["RequestTicket"]["fare"]
    # # TODO # comment out, calling events in brownie currently got issues: https://ethereum.stackexchange.com/questions/122362/brownie-exceptions-eventlookuperror-event-xxx-did-not-fire
    # # use hacky way to get ticket_id first:
    ticket_id = ride_ticket.getUserToTixId(person2)

    # 4 # --> driver accept ticket
    badge_used = 0

    tx = ride_driver.acceptTicket(
        key_USD, key_wETH, ticket_id, badge_used, {"from": person1}
    )
    tx.wait(1)

    assert ride_ticket.getUserToTixId(person1) == ticket_id  # driver active

    # 5 # --> driver reaches passenger location

    # 6 # --> passenger starts trip, scan QR code .. etc
    tx = ride_passenger.startTrip(person1, {"from": person2})
    tx.wait(1)

    # 7 # --> driver indicates destination reached

    # 8 # --> driver ends trip
    destination_reached = True

    tx = ride_driver.endTripDrv(destination_reached, {"from": person1})
    tx.wait(1)

    # 9 # --> passenger agrees, ends trip and gives rating
    agree = True
    rating = 4

    tx = ride_passenger.endTripPax(agree, rating, {"from": person2})
    tx.wait(1)

    # 10 # --> the wETH that was used for payment are transferred from passenger to driver
    assert ride_holding.getHolding(person1, key_wETH) > ride_holding.getHolding(
        person2, key_wETH
    )
    # TODO: compare the exact amount using fare from events once events are fixed

    # 11 # --> clean up
    assert ride_ticket.getUserToTixId(person1) == utils.ZERO_BYTES32  # not active
    assert ride_ticket.getUserToTixId(person2) == utils.ZERO_BYTES32  # not active


def test_drv_indicate_dst_reached_pax_disagrees(
    ride_hub,
    ride_currency_registry,
    ride_holding,
    ride_badge,
    ride_driver_registry,
    ride_ticket,
    ride_passenger,
    ride_driver,
    ride_WETH9,
    deployer,
    person1,
    person2,
):
    # 1 # --> setup
    key_USD, key_wETH = _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_badge,
        ride_driver_registry,
        ride_ticket,
        ride_WETH9,
        deployer,
        person1,
        person2,
    )

    # 2 # --> passenger request ticket
    badge_requested = 0
    strict = False
    estimated_minutes = 2
    estimated_metres = 100

    tx = ride_passenger.requestTicket(
        key_USD,
        key_wETH,
        badge_requested,
        strict,
        estimated_minutes,
        estimated_metres,
        {"from": person2},
    )
    tx.wait(1)

    # # 3 # --> get ticket to display to driver
    # assert tx.events["RequestTicket"]["sender"] == person2
    # assert ride_ticket.getUserToTixId(person2) == ticket_id # passenger active
    # ticket_id = tx.events["RequestTicket"]["tixId"]
    # trip_fare = tx.events["RequestTicket"]["fare"]
    # # TODO # comment out, calling events in brownie currently got issues: https://ethereum.stackexchange.com/questions/122362/brownie-exceptions-eventlookuperror-event-xxx-did-not-fire
    # # use hacky way to get ticket_id first:
    ticket_id = ride_ticket.getUserToTixId(person2)

    # 4 # --> driver accept ticket
    badge_used = 0

    tx = ride_driver.acceptTicket(
        key_USD, key_wETH, ticket_id, badge_used, {"from": person1}
    )
    tx.wait(1)

    assert ride_ticket.getUserToTixId(person1) == ticket_id  # driver active

    # 5 # --> driver reaches passenger location

    # 6 # --> passenger starts trip, scan QR code .. etc
    tx = ride_passenger.startTrip(person1, {"from": person2})
    tx.wait(1)

    # 7 # --> driver indicates destination reached

    # 8 # --> driver ends trip
    destination_reached = True

    tx = ride_driver.endTripDrv(destination_reached, {"from": person1})
    tx.wait(1)

    # 9 # --> passenger disagrees, can't end trip
    agree = False
    rating = 4

    with brownie.reverts(
        "RidePassenger: Passenger must agree destination reached or not - indicated by driver"
    ):
        ride_passenger.endTripPax(agree, rating, {"from": person2})

    # 10 # --> driver switches destination status (this change is reflected in passenger UI)
    # note: because driver may need switch the destiantion status at any time, this UI showing
    #       endTripDrv function should persists
    destination_reached = False

    tx = ride_driver.endTripDrv(destination_reached, {"from": person1})
    tx.wait(1)

    # 11 # --> passenger agrees, ends trip and gives rating
    agree = True
    rating = 4

    tx = ride_passenger.endTripPax(agree, rating, {"from": person2})
    tx.wait(1)

    # 12 # --> the wETH that was used for payment are transferred from passenger to driver *****
    assert ride_holding.getHolding(person1, key_wETH) > ride_holding.getHolding(
        person2, key_wETH
    )
    # TODO: compare the exact amount using fare from events once events are fixed

    # 13 # --> clean up
    assert ride_ticket.getUserToTixId(person1) == utils.ZERO_BYTES32  # not active
    assert ride_ticket.getUserToTixId(person2) == utils.ZERO_BYTES32  # not active


def test_drv_indicate_dst_NOT_reached_pax_agrees(
    ride_hub,
    ride_currency_registry,
    ride_holding,
    ride_badge,
    ride_driver_registry,
    ride_ticket,
    ride_passenger,
    ride_driver,
    ride_WETH9,
    deployer,
    person1,
    person2,
):
    # 1 # --> setup
    key_USD, key_wETH = _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_badge,
        ride_driver_registry,
        ride_ticket,
        ride_WETH9,
        deployer,
        person1,
        person2,
    )

    # 2 # --> passenger request ticket
    badge_requested = 0
    strict = False
    estimated_minutes = 2
    estimated_metres = 100

    tx = ride_passenger.requestTicket(
        key_USD,
        key_wETH,
        badge_requested,
        strict,
        estimated_minutes,
        estimated_metres,
        {"from": person2},
    )
    tx.wait(1)

    # # 3 # --> get ticket to display to driver
    # assert tx.events["RequestTicket"]["sender"] == person2
    # assert ride_ticket.getUserToTixId(person2) == ticket_id # passenger active
    # ticket_id = tx.events["RequestTicket"]["tixId"]
    # trip_fare = tx.events["RequestTicket"]["fare"]
    # # TODO # comment out, calling events in brownie currently got issues: https://ethereum.stackexchange.com/questions/122362/brownie-exceptions-eventlookuperror-event-xxx-did-not-fire
    # # use hacky way to get ticket_id first:
    ticket_id = ride_ticket.getUserToTixId(person2)

    # 4 # --> driver accept ticket
    badge_used = 0

    tx = ride_driver.acceptTicket(
        key_USD, key_wETH, ticket_id, badge_used, {"from": person1}
    )
    tx.wait(1)

    assert ride_ticket.getUserToTixId(person1) == ticket_id  # driver active

    # 5 # --> driver reaches passenger location

    # 6 # --> passenger starts trip, scan QR code .. etc
    tx = ride_passenger.startTrip(person1, {"from": person2})
    tx.wait(1)

    # 7 # --> driver indicates destination NOT reached

    # 8 # --> driver ends trip
    destination_reached = False

    tx = ride_driver.endTripDrv(destination_reached, {"from": person1})
    tx.wait(1)

    # 9 # --> passenger agrees, ends trip and gives rating
    agree = True
    rating = 4

    tx = ride_passenger.endTripPax(agree, rating, {"from": person2})
    tx.wait(1)

    # 10 # --> the wETH that was used for payment are transferred from passenger to driver
    assert ride_holding.getHolding(person1, key_wETH) > ride_holding.getHolding(
        person2, key_wETH
    )
    # TODO: compare the exact amount using fare from events once events are fixed

    # 11 # --> clean up
    assert ride_ticket.getUserToTixId(person1) == utils.ZERO_BYTES32  # not active
    assert ride_ticket.getUserToTixId(person2) == utils.ZERO_BYTES32  # not active


def test_drv_indicate_dst_NOT_reached_pax_disagrees(
    ride_hub,
    ride_currency_registry,
    ride_holding,
    ride_badge,
    ride_driver_registry,
    ride_ticket,
    ride_passenger,
    ride_driver,
    ride_WETH9,
    deployer,
    person1,
    person2,
):
    # 1 # --> setup
    key_USD, key_wETH = _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_badge,
        ride_driver_registry,
        ride_ticket,
        ride_WETH9,
        deployer,
        person1,
        person2,
    )

    # 2 # --> passenger request ticket
    badge_requested = 0
    strict = False
    estimated_minutes = 2
    estimated_metres = 100

    tx = ride_passenger.requestTicket(
        key_USD,
        key_wETH,
        badge_requested,
        strict,
        estimated_minutes,
        estimated_metres,
        {"from": person2},
    )
    tx.wait(1)

    # # 3 # --> get ticket to display to driver
    # assert tx.events["RequestTicket"]["sender"] == person2
    # assert ride_ticket.getUserToTixId(person2) == ticket_id # passenger active
    # ticket_id = tx.events["RequestTicket"]["tixId"]
    # trip_fare = tx.events["RequestTicket"]["fare"]
    # # TODO # comment out, calling events in brownie currently got issues: https://ethereum.stackexchange.com/questions/122362/brownie-exceptions-eventlookuperror-event-xxx-did-not-fire
    # # use hacky way to get ticket_id first:
    ticket_id = ride_ticket.getUserToTixId(person2)

    # 4 # --> driver accept ticket
    badge_used = 0

    tx = ride_driver.acceptTicket(
        key_USD, key_wETH, ticket_id, badge_used, {"from": person1}
    )
    tx.wait(1)

    assert ride_ticket.getUserToTixId(person1) == ticket_id  # driver active

    # 5 # --> driver reaches passenger location

    # 6 # --> passenger starts trip, scan QR code .. etc
    tx = ride_passenger.startTrip(person1, {"from": person2})
    tx.wait(1)

    # 7 # --> driver indicates destination NOT reached

    # 8 # --> driver ends trip
    destination_reached = False

    tx = ride_driver.endTripDrv(destination_reached, {"from": person1})
    tx.wait(1)

    # 9 # --> passenger disagrees, can't end trip
    agree = False
    rating = 4

    with brownie.reverts(
        "RidePassenger: Passenger must agree destination reached or not - indicated by driver"
    ):
        ride_passenger.endTripPax(agree, rating, {"from": person2})

    # 10 # --> driver switches destination status (this change is reflected in passenger UI)
    # note: because driver may need switch the destiantion status at any time, this UI showing
    #       endTripDrv function should persists
    destination_reached = True

    tx = ride_driver.endTripDrv(destination_reached, {"from": person1})
    tx.wait(1)

    # 11 # --> passenger agrees, ends trip and gives rating
    agree = True
    rating = 4

    tx = ride_passenger.endTripPax(agree, rating, {"from": person2})
    tx.wait(1)

    # 12 # --> the wETH that was used for payment are transferred from passenger to driver *****
    assert ride_holding.getHolding(person1, key_wETH) > ride_holding.getHolding(
        person2, key_wETH
    )
    # TODO: compare the exact amount using fare from events once events are fixed

    # 13 # --> clean up
    assert ride_ticket.getUserToTixId(person1) == utils.ZERO_BYTES32  # not active
    assert ride_ticket.getUserToTixId(person2) == utils.ZERO_BYTES32  # not active


###################################################################################################
##### --------------------------------------------------------------------------------------- #####
##### ------ what happens if passenger or driver never calls endTripPax or endTripDrv? ------ #####
##### --------------------------------------------------------------------------------------- #####
###################################################################################################


def test_endTripPax_never_called(
    ride_hub,
    ride_currency_registry,
    ride_holding,
    ride_badge,
    ride_driver_registry,
    ride_ticket,
    ride_passenger,
    ride_driver,
    ride_penalty,
    ride_WETH9,
    deployer,
    person1,
    person2,
):
    # 1 # --> setup
    key_USD, key_wETH = _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_badge,
        ride_driver_registry,
        ride_ticket,
        ride_WETH9,
        deployer,
        person1,
        person2,
    )

    # 2 # --> passenger request ticket
    badge_requested = 0
    strict = False
    estimated_minutes = 2
    estimated_metres = 100

    tx = ride_passenger.requestTicket(
        key_USD,
        key_wETH,
        badge_requested,
        strict,
        estimated_minutes,
        estimated_metres,
        {"from": person2},
    )
    tx.wait(1)

    # # 3 # --> get ticket to display to driver
    # assert tx.events["RequestTicket"]["sender"] == person2
    # assert ride_ticket.getUserToTixId(person2) == ticket_id # passenger active
    # ticket_id = tx.events["RequestTicket"]["tixId"]
    # trip_fare = tx.events["RequestTicket"]["fare"]
    # # TODO # comment out, calling events in brownie currently got issues: https://ethereum.stackexchange.com/questions/122362/brownie-exceptions-eventlookuperror-event-xxx-did-not-fire
    # # use hacky way to get ticket_id first:
    ticket_id = ride_ticket.getUserToTixId(person2)

    # 4 # --> driver accept ticket
    badge_used = 0

    tx = ride_driver.acceptTicket(
        key_USD, key_wETH, ticket_id, badge_used, {"from": person1}
    )
    tx.wait(1)

    assert ride_ticket.getUserToTixId(person1) == ticket_id  # driver active

    # 5 # --> driver reaches passenger location

    # 6 # --> passenger starts trip, scan QR code .. etc
    tx = ride_passenger.startTrip(person1, {"from": person2})
    tx.wait(1)

    # 7 # --> driver indicates destination reached

    # 8 # --> driver ends trip
    destination_reached = True

    tx = ride_driver.endTripDrv(destination_reached, {"from": person1})
    tx.wait(1)

    # 9 # --> passenger never calls endTripPax

    # 10 # --> fast-forward time
    chain.sleep(ride_ticket.getForceEndDelay() + 1)

    # 11 # --> after some time, driver force to end trip
    tx = ride_driver.forceEndDrv({"from": person1})
    tx.wait(1)

    # 12 # --> passenger is banned
    with brownie.reverts("RideLibPenalty: Still banned"):
        ride_passenger.requestTicket(
            key_USD,
            key_wETH,
            badge_requested,
            strict,
            estimated_minutes,
            estimated_metres,
            {"from": person2},
        )

    # 13 # --> fare never transferred between passenger and driver
    assert ride_holding.getHolding(person1, key_wETH) == ride_holding.getHolding(
        person2, key_wETH
    )
    # TODO: compare the exact amount using fare from events once events are fixed

    # 14 # --> clean up
    assert ride_ticket.getUserToTixId(person1) == utils.ZERO_BYTES32  # not active
    assert ride_ticket.getUserToTixId(person2) == utils.ZERO_BYTES32  # not active

    # 15 # --> ban duration passes
    chain.sleep(ride_penalty.getBanDuration())

    # 16 # --> passenger can request ride again
    tx = ride_passenger.requestTicket(
        key_USD,
        key_wETH,
        badge_requested,
        strict,
        estimated_minutes,
        estimated_metres,
        {"from": person2},
    )
    tx.wait(1)


def test_endTripDrv_never_called(
    ride_hub,
    ride_currency_registry,
    ride_holding,
    ride_badge,
    ride_driver_registry,
    ride_ticket,
    ride_passenger,
    ride_driver,
    ride_penalty,
    ride_WETH9,
    deployer,
    person1,
    person2,
):
    # 1 # --> setup
    key_USD, key_wETH = _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_badge,
        ride_driver_registry,
        ride_ticket,
        ride_WETH9,
        deployer,
        person1,
        person2,
    )

    # 2 # --> passenger request ticket
    badge_requested = 0
    strict = False
    estimated_minutes = 2
    estimated_metres = 100

    tx = ride_passenger.requestTicket(
        key_USD,
        key_wETH,
        badge_requested,
        strict,
        estimated_minutes,
        estimated_metres,
        {"from": person2},
    )
    tx.wait(1)

    # # 3 # --> get ticket to display to driver
    # assert tx.events["RequestTicket"]["sender"] == person2
    # assert ride_ticket.getUserToTixId(person2) == ticket_id # passenger active
    # ticket_id = tx.events["RequestTicket"]["tixId"]
    # trip_fare = tx.events["RequestTicket"]["fare"]
    # # TODO # comment out, calling events in brownie currently got issues: https://ethereum.stackexchange.com/questions/122362/brownie-exceptions-eventlookuperror-event-xxx-did-not-fire
    # # use hacky way to get ticket_id first:
    ticket_id = ride_ticket.getUserToTixId(person2)

    # 4 # --> driver accept ticket
    badge_used = 0

    tx = ride_driver.acceptTicket(
        key_USD, key_wETH, ticket_id, badge_used, {"from": person1}
    )
    tx.wait(1)

    assert ride_ticket.getUserToTixId(person1) == ticket_id  # driver active

    # 5 # --> driver reaches passenger location

    # 6 # --> passenger starts trip, scan QR code .. etc
    tx = ride_passenger.startTrip(person1, {"from": person2})
    tx.wait(1)

    # 7 # --> driver never calls endTripDrv

    # 8 # --> passenger tries to end trip, fails
    with brownie.reverts("RidePassenger: Driver must end trip"):
        ride_passenger.endTripPax(False, 1, {"from": person2})

    # 9 # --> fast-forward time
    chain.sleep(ride_ticket.getForceEndDelay() + 1)

    # 10 # --> after some time, passenger force to end trip
    tx = ride_passenger.forceEndPax({"from": person2})
    tx.wait(1)

    # 11 # --> driver is banned
    with brownie.reverts("RideLibPenalty: Still banned"):
        ride_driver.acceptTicket(
            key_USD, key_wETH, ticket_id, badge_used, {"from": person1}
        )

    # 12 # --> fare never transferred between passenger and driver
    assert ride_holding.getHolding(person1, key_wETH) == ride_holding.getHolding(
        person2, key_wETH
    )
    # TODO: compare the exact amount using fare from events once events are fixed

    # 13 # --> clean up
    assert ride_ticket.getUserToTixId(person1) == utils.ZERO_BYTES32  # not active
    assert ride_ticket.getUserToTixId(person2) == utils.ZERO_BYTES32  # not active

    # 14 # --> ban duration passes
    chain.sleep(ride_penalty.getBanDuration())

    # 15 # --> driver can accept ride again
    tx = ride_passenger.requestTicket(
        key_USD,
        key_wETH,
        badge_requested,
        strict,
        estimated_minutes,
        estimated_metres,
        {"from": person2},
    )
    tx.wait(1)
    ticket_id = ride_ticket.getUserToTixId(person2)

    tx = ride_driver.acceptTicket(
        key_USD, key_wETH, ticket_id, badge_used, {"from": person1}
    )
    tx.wait(1)


###################################################################################################
##### --------------------------------------------------------------------------------------- #####
##### ------ what happens if passenger or driver decides to cancel before trip begins? ------ #####
##### --------------------------------------------------------------------------------------- #####
###################################################################################################


def test_pax_cancels_before_drv_accept(
    ride_hub,
    ride_currency_registry,
    ride_holding,
    ride_badge,
    ride_driver_registry,
    ride_ticket,
    ride_passenger,
    ride_driver,
    ride_WETH9,
    deployer,
    person1,
    person2,
):
    # 1 # --> setup
    key_USD, key_wETH = _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_badge,
        ride_driver_registry,
        ride_ticket,
        ride_WETH9,
        deployer,
        person1,
        person2,
    )

    # 2 # --> passenger request ticket
    badge_requested = 0
    strict = False
    estimated_minutes = 2
    estimated_metres = 100

    tx = ride_passenger.requestTicket(
        key_USD,
        key_wETH,
        badge_requested,
        strict,
        estimated_minutes,
        estimated_metres,
        {"from": person2},
    )
    tx.wait(1)

    # # 3 # --> get ticket to display to driver
    # assert tx.events["RequestTicket"]["sender"] == person2
    # assert ride_ticket.getUserToTixId(person2) == ticket_id # passenger active
    # ticket_id = tx.events["RequestTicket"]["tixId"]
    # trip_fare = tx.events["RequestTicket"]["fare"]
    # # TODO # comment out, calling events in brownie currently got issues: https://ethereum.stackexchange.com/questions/122362/brownie-exceptions-eventlookuperror-event-xxx-did-not-fire
    # # use hacky way to get ticket_id first:
    ticket_id = ride_ticket.getUserToTixId(person2)

    # 4 # --> passenger cancels request
    tx = ride_passenger.cancelRequest({"from": person2})
    tx.wait(1)

    # 5 # --> no cancellation fee charged, no transfers from passenger to driver
    assert ride_holding.getHolding(person1, key_wETH) == ride_holding.getHolding(
        person2, key_wETH
    )
    # TODO: compare the exact amount using fare from events once events are fixed

    # 6 # --> clean up
    assert ride_ticket.getUserToTixId(person1) == utils.ZERO_BYTES32  # not active
    assert ride_ticket.getUserToTixId(person2) == utils.ZERO_BYTES32  # not active


def test_pax_cancels_drv_already_accept(
    ride_hub,
    ride_currency_registry,
    ride_holding,
    ride_badge,
    ride_driver_registry,
    ride_ticket,
    ride_passenger,
    ride_driver,
    ride_WETH9,
    deployer,
    person1,
    person2,
):
    # 1 # --> setup
    key_USD, key_wETH = _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_badge,
        ride_driver_registry,
        ride_ticket,
        ride_WETH9,
        deployer,
        person1,
        person2,
    )

    # 2 # --> passenger request ticket
    badge_requested = 0
    strict = False
    estimated_minutes = 2
    estimated_metres = 100

    tx = ride_passenger.requestTicket(
        key_USD,
        key_wETH,
        badge_requested,
        strict,
        estimated_minutes,
        estimated_metres,
        {"from": person2},
    )
    tx.wait(1)

    # # 3 # --> get ticket to display to driver
    # assert tx.events["RequestTicket"]["sender"] == person2
    # assert ride_ticket.getUserToTixId(person2) == ticket_id # passenger active
    # ticket_id = tx.events["RequestTicket"]["tixId"]
    # trip_fare = tx.events["RequestTicket"]["fare"]
    # # TODO # comment out, calling events in brownie currently got issues: https://ethereum.stackexchange.com/questions/122362/brownie-exceptions-eventlookuperror-event-xxx-did-not-fire
    # # use hacky way to get ticket_id first:
    ticket_id = ride_ticket.getUserToTixId(person2)

    # 4 # --> driver accept ticket
    badge_used = 0

    tx = ride_driver.acceptTicket(
        key_USD, key_wETH, ticket_id, badge_used, {"from": person1}
    )
    tx.wait(1)

    assert ride_ticket.getUserToTixId(person1) == ticket_id  # driver active

    # 5 # --> passenger cancels request, before startTrip called
    tx = ride_passenger.cancelRequest({"from": person2})
    tx.wait(1)

    # 6 # --> cancallation fee transferred from passenger to driver
    assert ride_holding.getHolding(person1, key_wETH) > ride_holding.getHolding(
        person2, key_wETH
    )
    # TODO: compare the exact amount using fare from events once events are fixed

    # 7 # --> clean up
    assert ride_ticket.getUserToTixId(person1) == utils.ZERO_BYTES32  # not active
    assert ride_ticket.getUserToTixId(person2) == utils.ZERO_BYTES32  # not active


def test_drv_cancels_trip(
    ride_hub,
    ride_currency_registry,
    ride_holding,
    ride_badge,
    ride_driver_registry,
    ride_ticket,
    ride_passenger,
    ride_driver,
    ride_WETH9,
    deployer,
    person1,
    person2,
):
    # 1 # --> setup
    key_USD, key_wETH = _setup(
        ride_hub,
        ride_currency_registry,
        ride_holding,
        ride_badge,
        ride_driver_registry,
        ride_ticket,
        ride_WETH9,
        deployer,
        person1,
        person2,
    )

    # 2 # --> passenger request ticket
    badge_requested = 0
    strict = False
    estimated_minutes = 2
    estimated_metres = 100

    tx = ride_passenger.requestTicket(
        key_USD,
        key_wETH,
        badge_requested,
        strict,
        estimated_minutes,
        estimated_metres,
        {"from": person2},
    )
    tx.wait(1)

    # # 3 # --> get ticket to display to driver
    # assert tx.events["RequestTicket"]["sender"] == person2
    # assert ride_ticket.getUserToTixId(person2) == ticket_id # passenger active
    # ticket_id = tx.events["RequestTicket"]["tixId"]
    # trip_fare = tx.events["RequestTicket"]["fare"]
    # # TODO # comment out, calling events in brownie currently got issues: https://ethereum.stackexchange.com/questions/122362/brownie-exceptions-eventlookuperror-event-xxx-did-not-fire
    # # use hacky way to get ticket_id first:
    ticket_id = ride_ticket.getUserToTixId(person2)

    # 4 # --> driver accept ticket
    badge_used = 0

    tx = ride_driver.acceptTicket(
        key_USD, key_wETH, ticket_id, badge_used, {"from": person1}
    )
    tx.wait(1)

    assert ride_ticket.getUserToTixId(person1) == ticket_id  # driver active

    # 5 # --> driver cancels after accepting ticket
    tx = ride_driver.cancelPickUp({"from": person1})
    tx.wait(1)

    # 6 # --> cancallation fee transferred from driver to passenger
    assert ride_holding.getHolding(person1, key_wETH) < ride_holding.getHolding(
        person2, key_wETH
    )
    # TODO: compare the exact amount using fare from events once events are fixed

    # 7 # --> clean up
    assert ride_ticket.getUserToTixId(person1) == utils.ZERO_BYTES32  # not active
    assert ride_ticket.getUserToTixId(person2) == utils.ZERO_BYTES32  # not active


###########################################
##### ------------------------------- #####
##### ----------- withdraw ---------- #####
##### ------------------------------- #####
###########################################


def test_withdraw(ride_hub, ride_currency_registry, ride_holding, ride_WETH9, person1):
    # 1 # --> setup
    deposit(ride_hub, ride_currency_registry, ride_holding, ride_WETH9, person1)

    # 2 # --> withdraw from RideHub to wallet
    key_wETH = ride_currency_registry.getKeyCrypto(ride_WETH9.address)

    assert ride_WETH9.balanceOf(person1) == 0

    amount = ride_holding.getHolding(person1, key_wETH)

    tx = ride_holding.withdrawTokens(key_wETH, amount, {"from": person1})
    tx.wait(1)

    assert ride_holding.getHolding(person1, key_wETH) == 0

    # 3 # --> check wallet

    assert ride_WETH9.balanceOf(person1) == amount
