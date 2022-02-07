- supply demo DApp to grant

- do integration test for add/replace/remove of diamond facets

- do token (from RideHub) + governance deploy script

- do integration test for token + governance

- add deposit/withdraw features of permit to RideHub
- ERC20Permit: Test if calling increaseAllowance/decreaseAllowance works with permit as well? i.e calling permit then increase/decrease.
- ERC20Permit: can just call permit multiple times to act as increasing allowance as well? (besides transferring)
- Change RideHub to use SafeERC20/SafeERC20Permit libraries.
- Implement RIDE Token Specs as above.
- ERC20Votes: Test governance on Box.sol.
- How to talk to RideHub diamond pattern contract?
- Study if need add special functions to Ride.sol if in future want make it mappable/bridgeable to Ethereum: https://docs.polygon.technology/docs/develop/ethereum-polygon/mintable-assets#what-are-the-requirements-to-be-satisfied
Ans: yes need add special fns, and need a child contract in Ethereum as well.
Ans2: this is like ERC20Wrapper?


- RIDE minting strategy (refactor script & test accordingly)

- RIDE deployment strategy (which chain, RideHub can be deployed on every chain, but RIDE token may not want that as to prevent simply increasing supply) (refactor script & test accordingly)

- add location data into Ticket struct - study how location data looks like / data type
ans: data input will either be in the form of:
1. Place ID
2. Address (last choice)
3. Coordinates (latitude/longitude)

- store to display list of ticket ID, use emitted event (RequestTicket) to query 
1. record 1 by 1 as it emits, and remove once deleted (TicketCleared event) [off-chain solution]
2. query historical events, expensive? what is the best way to do? "indexed"? (tixId of RequestTicket - TicketCleared)? [off-chain solution]
3. The Graph protocol? [?-chain solution]
note: dont really need store list of driver/passenger as passenger/driver dont really "need" to see if driver/passenger available, if passenger wants ride just request ticket, if no dirver means ticket never accepted. if driver wants pick passenger just find ticket, no ticket means no passenger.

- how easy is it to bridge between Ethereum / Avalanche / Polygon ?

- RideHub: do transfer driver account feature (to new address), maybe require revalidation of identity/background checks etc..
- allow governance participation via RIDE tokens, or for drivers, metres travelled as well.

## ::: Convenience Service :::

- do service to bridge Ethereum tokens/coins to Polygon (see docs)

- fiat-on-Ramp: https://docs.polygon.technology/docs/develop/fiat-on-ramp

## ::: Others :::

- allow anyone to add any token pair if not addeed already?

- rethink RideBadge

- launch on Avalanche? Near? see vs Polygon.

- provide gasless transaction service: https://docs.polygon.technology/docs/develop/metatransactions/getting-started (OR ERC20Permit !!!)

- study licenses/IP for code? why ppl cant copy uniswap V3 code? https://www.newsbtc.com/news/can-uniswap-v3-prevent-forks-top-lawyer-breakdowns-its-license/