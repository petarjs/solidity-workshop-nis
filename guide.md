# Solidity Workshop Nis

We are going to create a decentralized platform for asking and answering questions.

## Required softweare

To follow this guide you'll need to install the following:

- NodeJS & npm
- Truffle
- Metamask

## Creating the project

Create the directory where your project will live, and then initialize the project using Truffle:

```sh
mkdir solidity-workshop
cd solidity-workshop
truffle init
```

After that, you'll see that Truffle generated a bunch of files and folders, that we'll use to develop the project.

## Configuring the project

We need to configure the project to tell Truffle how to connect to the blockchain. While developing, we'll use Truffle's built in Ethereum blockchain simulation. To deploy your contracts to a testnet or the mainnet later, just add the required configuration entries.

The configuration for UNIX based systems is held in `truffle.js`, and for Windows please use `truffle-config.js`.

Add this to your configuration file:

```js
module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 9545,
      network_id: "*"
    }
  }
}
```

## Creating the contract

Now, in your `contracts` directory, create a file named `Dask.sol`. Here we'll write our code.

## Compiling

To compile your solidity contracts, use this command:

```sh
truffle compile
```

## Migrations

Migrations are files that define how your contracts will be deployed to blockchain. They live in the `migrations` folder. You can just copy-paste the already provided `1_initial_migration.js` and change the code to match your contract's name.

To migrate your contracts to the blockchain, there are several prerequisites:

1. You compiled your contracts.
2. You have the blockchain defined in the `truffle.js` running.

To start Truffle's test blockchain, just run:

```sh
truffle develop
```

This command needs to continue running for as long you're developing, so it's best to run it in a new terminal window.

Now that we have the test blockchain running, we can migrate the contracts by executing:

```sh
truffle migrate
```

This command uses the development config from `truffle.js`. If you want to migrate to a different network, you can specify that using the `--network` argument (e.g. `truffle migrate --network ropsten`).

## Interact with the blockchain

When you ran `truffle develop`, it generated some acconuts for you, and preloaded them with some ether, so you don't need to worry about that. Ether is required for sending transactions and calling smart contract methods that modify the contract's state.

Inside the console, you can query and modify the blockchain state by using the `web3` object. For example, to find out how many weis there are in one ether, run:

```js
web3.toWei(1, 'ether')
```

All the accounts that Truffle generated for us are stored in `web3.eth.accounts`. For example, to find out how much ether the first account has, run:

```js
web3.eth.getBalance(web3.eth.accounts[0])
```

## Transfering ether

Let's say we wanted to transfer 2 ether from the first to the second account. First, let's find out how much ether each has.

```js
web3.eth.getBalance(web3.eth.accounts[0])
web3.eth.getBalance(web3.eth.accounts[1])
```

We see that they each have 1000000 ether.

To make the transaction, we'll use the `web3.eth.sendTransaction` method.

```js
web3.eth.sendTransaction({
    from: web3.eth.accounts[0],
    to: web3.eth.accounts[1],
    value: web3.toWei(2, 'ether')
})
```

Now if we check how much each account has, we'll see it changed.

## Calling methods on our smart contract

First, we need to obtain a reference to our deployed contract. We do that by executing:

```js
let dask
Dask.deployed().then(d => dask = d)
```

After that, we'll have the contract in `dask` variable, and will be able to interact with it. For example, we might want to know the price per answer:

```js
dask.getPricePerAnswer()
```

## Interacting with our smart contract from JavaScript

To interact with the blockchain from our webpage, we'll use the `web3` library. Instead of importing the lib ourselves, we'll install the Metamask Chrome extension which will inject the `web3` object into our webpage. By doing this we can call methods on the blockchain, like transfering ether and getting address balances.

But to interact with our smart contract, we need to let `web3` know how to talk to it. We do this by providing an ABI of our smart contract to `web3`. ABI (application binary interface) is simply a JSON representation of our smart contract's interface (a list of methods, arguments, types...). To see how an ABI looks, we can look into our `build/contracts/` folder. If we open `Dask.json`, among other properties, we'll see the `abi` property. We want to copy this and paste it into our webpage.

The second thing we need is the address to which our smart contract is deployed on the blockchain. We can get this by typing the following into the `truffle develop` console:

```js
Dask.deployed()
```

In the output you'll see an `address` property. Copy this too and paste into the webpage.

Now, it's finally time to instantiate our contract and be able to call its methods from JavaScript. We do this by:

```js
let daskContract = web3.eth.contract(abi).at(address)
```

## Deploying to Ropsten testnet

After finishing the smart contract in the local development environment, we should deploy it to the Ropsten Testnet.

To deploy a Smart Contract to the Ropsten network, we have to have Ether to pay for Gas (fees for the deployment). Following are the steps to get free Ether:

1. Click Metamask on Chrome, select Testnet - Ropsten.
2. Create a new account on Ropsten Network.
3. To get free Ether, we click BUY button from the account screen
4. Click ROPSTEN TEST FAUCET to go site https://faucet.metamask.io/. 
5. On the site, we click the button "Request 1 ether from faucet".
6. Waiting a bit, and you'll have 1 Ether in our account!

Now it's time to configure Truffle to be able to deploy to Ropsten.

Install the `truffle-hdwallet-provider` npm package by running the following command in the terminal:

```sh
npm i --save truffle-hdwallet-provider
```

Next, find out your Metamask seed phrase (Metamask -> Settings -> Reveal Seed Words) and copy it into a variable on top of `truffle.js`:

```js
const mnemonic = 'crowd party laugh address sheriff fix trend pen present boost oil castle'
```

Add a new network in the configuration object in `truffle.js`:

```js
    ropsten:  {
      network_id: 3,
      provider: function() {
        return new HDWalletProvider(mnemonic, `https://ropsten.infura.io`)
      },
      gas: 3712388
    }
```

Finally, run the migrate command in the terminal, specifying the network:

```sh
truffle migrate --network=ropsten
```

That's it!