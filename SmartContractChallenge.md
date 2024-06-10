## Technical Challenge for Interview: ERC20 Token Swap and Transfer
### USer Story
I want to let people pay for gas fees with ERC20. In doing so I'm making our users pay with ERC20 for gas while I subsidize with native token the operation. Given the ERC20 I'm receiving I want to be able to swap this ERC20 to stablecoin and send it to a smart contrcact.

### Objective:
Create an on-chain solution where an ERC20 token is sent to a smart contract, which then swaps it to another token (USDC) and sends it to different recipients. The solution should allow developers to choose the recipients, include any fees, and specify the timing of the action (immediate, once per day, etc.).
### Requirements:
- Smart contract:
A payable smart contract that swaps all tokens received into the output token before forwarding to the beneficiary. 
- Fees:
The smart contract should be able to include any fees associated with the token swap and transfer.
- Timing:
The action should be able to be triggered at a specific time (e.g., immediately after reception, once per day, etc.).

## Evaluation Criteria:
- Functionality: The contract should correctly split and swap tokens according to pre-set percentages and allow the owner to modify: change oracles and discounts, pause Swappers, and execute arbitrary transactions.
- Blockchain Compatibility: The contract should be deployable on multiple blockchain platforms, including BNB, Optimism, Polygon, and Arbitrum.
- Code Quality and Readability: The code should be well-organized, readable, and follow best practices for smart contract development.
