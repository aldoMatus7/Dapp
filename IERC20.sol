// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./getEthPrice.sol";

contract iERC20 is ERC20, getEthPrice {
    uint256 tokenPriceUSD = 10 * 10 **8;
    constructor() ERC20("Chespin Coin", "CHC") {
        _mint(address(this), 100000 * 10**18);
    }


    /* El costo por un token al precio de 167264063193 ($1,672.64063193 USD) 
    es igual a 597857 (0.00597857 ETH)
    */
    function getCost(uint _amount) public view  returns(uint256){
        return (tokenPriceUSD * (_amount *10 **8) ) / uint256(getOnlyEthPrice());
    }

    function sellTokens(uint _amount) public payable returns(bool success) {
        // VERIFICAR QUE LO QUE NOS ESTEN MANDANDO SEA IGUAL O MAYOR DEL COSTO POR LA CANTIDAD REQUERIDA
        require(msg.value >= getCost(_amount), "Value is not enough");
        // VALIDAR QUE EL CONTRATO TENGA LOS TOKENS SUFICIENTES PARA VENDER 
        require(_amount * 10 **18 <= balanceOf(address(this)));
        // actualizar balances
        _transfer(address(this), msg.sender, _amount * 10 **18);

        //retornamos true
        return true;
    }
