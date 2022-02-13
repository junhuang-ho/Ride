- supply demo DApp to grant

- Ensure states only exists in library solidity files. No where else.

- look through all contracts replace those input params that is contract address, with the contract type itself (internally still read as address).

- lookout for SafeERC20Permit OZ implementation

- calling ERC20Permit deposit a second time in a row - having issues

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

- change unit test to be deployed from individual contracts instead of RideHub!

- allow anyone to add any token pair if not addeed already?

- rethink RideBadge

- launch on Avalanche? Near? see vs Polygon.

- provide gasless transaction service: https://docs.polygon.technology/docs/develop/metatransactions/getting-started (OR ERC20Permit !!!)

- study licenses/IP for code? why ppl cant copy uniswap V3 code? https://www.newsbtc.com/news/can-uniswap-v3-prevent-forks-top-lawyer-breakdowns-its-license/
