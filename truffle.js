const HDWalletProvider = require('truffle-hdwallet-provider')

const mnemonic = 'crowd party laugh address sheriff fix trend pen present boost oil castle'

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 9545,
      network_id: "*"
    },
    ropsten:  {
      network_id: 3,
      provider: function() {
        return new HDWalletProvider(mnemonic, `https://ropsten.infura.io`)
      },
      gas: 3712388
    }
  }
}
