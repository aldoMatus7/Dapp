import logo from './blockdemy.svg';
import './App.css';
import {useState} from 'react'
import Web3 from 'web3/dist/web3.min'
import ABI from "./ABI.js"

function App() {
  const CONTRACT_ADDRESS = "0xAc3da2aa4A44A9E393312B2e158eaB51a532cAa6"
  const [wallet, setWallet] = useState(null)
  const [contract, setContract] = useState(null)
  const [web3Provider, setWeb3] = useState(null)
  const [contractName, setContractName] = useState(null)
  const [cost, setCost] = useState(null)
  const [ethPrice, setEthPrice] = useState(null)
  const [balance, setBalanceOf] = useState(null)

  const connectToMetamask = async () =>{
    // validar que existe window.ethereum
    if(typeof window.ethereum !== undefined){
      console.log("Metamask is Installed")
      const wallet = await window.ethereum.request({method:'eth_requestAccounts'})
      setWallet(wallet)
      getContractinstance(window.ethereum,ABI, CONTRACT_ADDRESS, wallet)

    } else {
      console.log("Need to install Metamask")
    }
  }

  async function getContractinstance (provider,ABI, CONTRACT_ADDRESS, wallet){
    try{
      const web3 = new Web3(provider);
      setWeb3(web3)
      const contract = new web3.eth.Contract(ABI, CONTRACT_ADDRESS);
      setContract(contract)
      // Llamar a nuestras funciones del contrato inteligente
      getContractName(contract)
      getCost(contract, 1)
      getEthPrice(contract)
      getBalanceOf(contract, wallet[0])
    } catch (error){
      console.log(error)

    }
  }

  async function getContractName(contract) {
    const name = await contract.methods.name().call()
    setContractName(name)
  }

  // getcostOf 1 token
  async function getCost(contract, amount) {
    let cost = await contract.methods.getCost(amount).call()
    cost = cost * 10 ** -8
    setCost(cost)
    return cost
  }

  // get latest eth price
    async function getEthPrice(contract) {
      let price = await contract.methods.getOnlyEthPrice().call()
      price = price * (10**-8)
      setEthPrice(price)
    }
  // get balance of
  async function getBalanceOf(contract, address) {
    let balance = await contract.methods.balanceOf(address).call()
    balance = balance * 10**-18
    setBalanceOf(balance)
  }



  // buy tokens
  async function sellTokens(amount){
    let cost = await getCost(contract, amount)
    console.log(cost)
    cost = web3Provider.utils.toWei(cost.toString() ,'ether')
    console.log(cost)
    const transaction = await contract.methods.sellTokens(amount).send(
      {
        from: wallet[0],
        value: cost
      }
    )
    console.log(transaction)
  }



  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
       {wallet? (
         <button id="Connected">Conectado</button>
       ) : (
         <button id="ConnectToWallet" onClick={()=>{connectToMetamask()}}>Conectar con Metamask</button>
       )}
      
       
      </header>
      {wallet? (
      <div id='container'>
        <div id='message'>
          <h1>Con nuestro <span>{contractName}</span> se parte de nuestra comunidad</h1>
          <h1> <span></span></h1>
        </div>
        <div id='boxDetails'>
          <p>Contrato:<span>{CONTRACT_ADDRESS}</span></p>
          <p>Mi cuenta:<span>{wallet[0]}</span></p>
          <p>Mi balance:<span>{balance} CHC</span></p>
          <p>Precio Ether:<span> ${ethPrice} USD</span></p>
          <button onClick={()=>{
            sellTokens(1)
          }}> Comprar un Token</button>
        </div>
      </div>
      ) : (
        <div id='noWallet'>
          <h1>Por favor conecta con tu wallet</h1>
        </div>
      )}
    </div>
  );
}

export default App;