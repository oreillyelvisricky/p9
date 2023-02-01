const ethers = require("ethers")

const WALLET_CONTRACT_ARTIFACT_PATH = process.env.WALLET_CONTRACT_ARTIFACT_PATH
const WALLET_CONTRACT_ADDRESS = process.env.WALLET_CONTRACT_ADDRESS

const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY
const METAMASK_PKEY = process.env.METAMASK_PKEY

const provider = new ethers.providers.AlchemyProvider(network="goerli", ALCHEMY_API_KEY)
const signer = new ethers.Wallet(METAMASK_PKEY, provider)

const WalletContract = require(WALLET_CONTRACT_ARTIFACT_PATH)
const walletContract = new ethers.Contract(WALLET_CONTRACT_ADDRESS, WalletContract.abi, signer)

async function main() {
  console.log(">>> walletContract.test()")
  await walletContract.test(WALLET_CONTRACT_ADDRESS)
}

main().catch(error => {
  console.log(error)
  process.exitCode = 1
})

walletContract.on("LogNumTransferLayers", (numTransferLayers) => {
  console.log("EVENT Wallet: LogNumTransferLayers")
  console.log("numTransferLayers:", numTransferLayers)
})

walletContract.on("LogTransferInQueue", (transferNum, receiver, amount, transferLayersIndex, executed) => {
  console.log("EVENT Wallet: LogTransferInQueue")

  console.log("transferNum:", transferNum)
  console.log("reveiver:", receiver)
  console.log("amount:", amount)

  console.log("transferLayersIndex:", transferLayersIndex)

  console.log("executed:", executed)
})
