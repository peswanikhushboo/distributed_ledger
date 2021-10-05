let fs = require('fs');
let Web3 = require('web3');

let web3 = new Web3;
web3.setProvider(new web3.providers.HttpProvider('http://127.0.0.1:7545'));

let contractAddress = "0x8bd621Ac6412F3924AF00657301B4A2c48f838b8";
let fromAddress = "0x1A6675fE98CA2259d6544aF947B834a89a5C26eE";
let abiStr = fs.readFileSync('interact/abi_PropertyTransfer.json', 'utf8');
let abi = JSON.parse(abiStr);

let propertyTransferContracts = new web3.eth.Contract(abi, contractAddress);

sendTransaction()
    .then(function() {
        console.log("Done");
    })
    .catch(function(error) {
        console.log(error);
    })

async function sendTransaction() {
    console.log("Alloting Property");
    await propertyTransferContracts.methods.allotProperty("0xdA73514258fD8674488Ba49F86FF67D3813C18F5","Property 1").send({from: fromAddress});

    console.log("Transferring Property");
    await propertyTransferContracts.methods.transferProperty("0x75C9835f9f70b2d7C5334fbAcF1A2feA160302E2","Property 1").send({from: fromAddress});

}
