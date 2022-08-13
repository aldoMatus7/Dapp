// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

interface IERC20{
    function totalSupply() external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFrom(address _owner, address _buyer, uint256 _value) external returns (bool success);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    //Eventos
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}

contract ERC20 is IERC20{

    //variables

    //Nombre del token
    string public constant name = "Chespin Coin";
    //Simbolo
    string public constant symbol = "CHC";

    //Decimales
    uint8 public constant decimals = 18;

    mapping (address => uint256) balances;

    //Permitir a alguien más gastar un token
    mapping (address => mapping (address => uint256) ) allowed;

    //Total supply 
    //10 ether => 10 0000000000
    uint256 totalSupply_ = 10 ether;

    //Constructor
    constructor (){
        balances[msg.sender] = totalSupply_;
    }

    //Funciones

    //Indica el total Supply
    function totalSupply() public override view returns (uint256){
        return totalSupply_;
    }

    //Devuelve el balance de una cuenta especifica
    function balanceOf(address _owner) public override view returns (uint256 balance){
        return balances[_owner];
    }

    //Tansferir de una cuenta a otra
    function transfer(address _to, uint256 _value) public override returns (bool success){
        require (_value <= balances[msg.sender], "El balance del owner es menor que el requerido");
        //Quitarle al msg.sender
        balances[msg.sender] = balances[msg.sender] - _value;
        //Sumarle al receptor
        balances[_to] = balances[_to] + _value;
        //Activar el evento transfer
        emit Transfer(msg.sender, _to, _value);

        return true; 
    }

 
    function transferFrom(address _owner, address _buyer, uint256 _value) public override returns (bool success){
        require (_value <= balances[_owner], "El balance del owner es menor que el requerido");
        require (_value <= allowed[_owner][msg.sender], "El permitido del owner es menor que el requerido");

        balances[_owner] = balances[_owner] - _value;
        allowed[_owner][msg.sender] = allowed[_owner][msg.sender] - _value;
        balances[_buyer] = balances[_buyer] + _value;
        //Activar el evento transfer
        emit Transfer(_owner, _buyer, _value);
        return true; 
    }

    //Permitir gastar cierta cantidad de token a una address
    function approve(address _spender, uint256 _value) public override returns (bool success){
        allowed[msg.sender][_spender] = _value;
        emit Approval( msg.sender, _spender, _value);
        return true;
    }

    //Retornar la cantidad de tokens permitidos para gastar de un owner
    function allowance(address _owner, address _spender) public override view returns (uint256 remaining){
        return allowed[_owner][_spender];
    }


}
