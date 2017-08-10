const HDWalletProvider = require("truffle-hdwallet-provider");
const fs = require("fs");

function getMnemonic() {
  if(fs.existsSync("secrets.json")) {
    let secrets = JSON.parse(fs.readFileSync("secrets.json", "utf8"));
    return secrets.mnemonic;
  } else {
    //throw new Error("No secrets.json found.");
  }
}

module.exports = {
  networks: {
    live: {
      network_id: 1 // Ethereum public network
      // optional config values
      // host - defaults to "localhost"
      // port - defaults to 8545
      // gas
      // gasPrice
      // from - default address to use for any transaction Truffle makes during migrations
    },
    kovan: {
      network_id: 42,
      provider: new HDWalletProvider(getMnemonic(), "https://kovan.infura.io"),
      gas: 4700000
    },
    testrpc: {
      network_id: "default"
    },
    development: {
      network_id: "default",
      host: "localhost",
      port: "8545"
    }
  },
  migrations_directory: './migrations'
};
