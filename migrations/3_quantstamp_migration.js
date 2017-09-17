var ERC20Lib = artifacts.require("./ERC20Lib.sol");
var SafeMathLib = artifacts.require("./SafeMathLib.sol");
var StandardToken = artifacts.require("./StandardToken.sol");

var Ownable = artifacts.require("./Ownable.sol");
var Pausable = artifacts.require("./Pausable.sol");


var PricingStrategy = artifacts.require("./PricingStrategy.sol");
var Quantstamp = artifacts.require("./Quantstamp.sol");

module.exports = function(deployer, network, accounts) {


    deployer.link(SafeMathLib, Quantstamp);
    deployer.link(PricingStrategy, Quantstamp);
    //deployer.link(StandardToken, Quantstamp);
    deployer.link(Ownable, Quantstamp);
    deployer.link(Pausable, Quantstamp);

    deployer.deploy(Quantstamp, 0x7e5f4552091a69125d5dfcb7b8c2659029395bdf, 1000, 100000, 60, StandardToken.address);
    //deployer.deploy(Quantstamp);

    /*
    deployer.then(function(){
        return StandardToken.new("QuantstampToken", "QSP", 10, 1000000000); // TODO: fill in appropriate values
    }).then(function(instance){
        deployer.deploy(Quantstamp, 0x7e5f4552091a69125d5dfcb7b8c2659029395bdf, 1000, 100000, 60, instance.address);
    });
    */
    /*
   deployer.deploy(StandardToken, "QuantstampToken", "QSP", 10, 1000000000).then(function(){ // TODO: fill in appropriate values
        console.log("StdToken Address: " + StandardToken.address);
        deployer.deploy(Quantstamp, 0x7e5f4552091a69125d5dfcb7b8c2659029395bdf, 1000, 100000, 60, StandardToken.address).then(function(){
            //console.log("QS test ");
            console.log("QS Address: " + Quantstamp.address);
        });

   });
   */ 

    //deployer.deploy(Quantstamp, 0x7e5f4552091a69125d5dfcb7b8c2659029395bdf, 1000, 100000, 60, StandardToken.address);
    //console.log("StdTokenOuter Address: " + StandardToken.address);

    //console.log("QSouter Address: " + Quantstamp.address);   
    
    /*
    var contract = Quantstamp.at(Quantstamp.address);
    var event = contract.TokenAddressEvent();
    event.watch(function(err, result){ console.log(result.args) });
    */
};