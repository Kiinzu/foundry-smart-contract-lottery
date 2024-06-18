# Provealy Random Raffle Contracts

## About

This code is to create a proveably random smart contract lottery.

## What we want it to do?
1. Users can enter by paying for a ticket
    1. The Ticket fees are going to go to the winner during the draw
2. After X period of time, the lottery will automatically draw a winner
    1. And this will be done programatically
3. Using Chainlink VRF & Chainlink Automation
    1. Chainlink VRF -> Randomness
    2. Chainlink Automation -> Time-Based Trigger

## Tests
1. Write some deploy scripts
2. Write our tests
    1. Work on a local chain

## Introduction
This Repository is meant ofr the Cyfrin course : Foundry Fundamentals, due to some of the updates that being implemented by either Chainlink and other external factor, the test was created **Only** for Local Anvil. The coverage looks like this

|---------------------------|-----------------|-----------------|---------------|----------------|
| File                      | % Lines         | % Statements    | % Branches    | % Funcs        |
|---------------------------|-----------------|-----------------|---------------|----------------|
| script/DeployRaffle.s.sol | 100.00% (14/14) | 100.00% (19/19) | 50.00% (1/2)  | 100.00% (1/1)  |
| script/HelperConfig.s.sol | 0.00% (0/10)    | 0.00% (0/15)    | 0.00% (0/2)   | 0.00% (0/2)    |
| script/Interaction.s.sol  | 54.29% (19/35)  | 44.44% (20/45)  | 50.00% (1/2)  | 33.33% (3/9)   |
| src/Raffle.sol            | 94.12% (32/34)  | 95.24% (40/42)  | 75.00% (6/8)  | 90.00% (9/10)  |
| test/mocks/LinkToken.sol  | 0.00% (0/10)    | 0.00% (0/12)    | 0.00% (0/2)   | 0.00% (0/3)    |
| Total                     | 63.11% (65/103) | 59.40% (79/133) | 50.00% (8/16) | 52.00% (13/25) |
|---------------------------|-----------------|-----------------|---------------|----------------|

## Testing

```
forge test
```

