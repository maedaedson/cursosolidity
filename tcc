// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "https://github.com/jeffprestes/cursosolidity/blob/master/bradesco_token_aberto.sol";

// Cadastro: 0xf8e81D47203A594245E36C48e151709F0C19fBe8

contract Cadastro {

    struct Cliente {
        uint256 id;
        string primeiroNome;
        string sobreNome;
        address payable endereco; //0x0
        bytes32 hashConta; // 0x0        
        bool existe; //false
    }

    uint256 public totalClientes;

    Cliente[] public clientes;

    function addCliente(
        string memory _primeiroNome,
        string memory _sobreNome,        
        string memory _agencia,
        string memory _conta
    ) external returns (bool) {
        string memory strTemp = string.concat(_agencia, _conta);
        bytes memory bTemp = bytes(strTemp);
        bytes32 hashTemp = keccak256(bTemp);

        Custodia custodiaTemp = new Custodia(hashTemp);

        Cliente memory cliente = Cliente(totalClientes, _primeiroNome, _sobreNome, payable(address(custodiaTemp)), hashTemp, true);
        totalClientes++;
        
        clientes.push(cliente);
        
        return true;
    }

    function getClientePeloId(uint256 _id) external view returns (Cliente memory cliente_, bool existe) {
        cliente_ = clientes[_id];
        existe = cliente_.existe;
        return (cliente_, existe);
    }

}

contract Custodia {
    bytes32 public hashConta;

    event EtherRecebido();

    constructor(bytes32 _hashConta) {
        hashConta = _hashConta;
    }

    receive() external payable {
        emit EtherRecebido();
    }
    
}
