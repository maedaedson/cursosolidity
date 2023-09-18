/*
SPDX-License-Identifier: CC-BY-4.0
(c) Desenvolvido por Jeff Prestes
This work is licensed under a Creative Commons Attribution 4.0 International License.
*/


//0xd9145CCE52D386f254917e481eB44e9943F39138

//valorAluguel 2 ether

pragma solidity 0.8.19;

contract Aluguel {
    string public locatario;
    string public locador;
    uint256 private valor;
    uint256 constant public numeroMaximoLegalDeAlugueisParaMulta = 3;
    bool[] public statusPagamento;
    /*
    0 - 01/2020 = true
    1 - 02/2020 = true
    2 - 03/2020 = true
    3 - 04/2020 = true
    */

    //Locador e a pessoa que tem a propriedade de um imóvel
    //Loatário e a pessoa que faz o pagamento mensal pelo aluguel do imóvel
    
    address payable public contaLocador;
   // address payable public contaLocatario;
    address public locatarioEndereco;

    constructor(    string memory _nomeLocador, 
                    string memory _nomeLocatario, 
                    address payable _contaLocador, 
                    //address payable _contaLocatario, 
                    uint256 _valorDoAluguel)  payable {
        locador = _nomeLocador;
        locatario = _nomeLocatario;
        valor = _valorDoAluguel;
        //contaLocatario = _contaLocatario;
        contaLocador = _contaLocador;
        //owner = msg.sender;
        locatarioEndereco = msg.sender;

    }
 
    function valorAtualDoAluguel() public view returns (uint256) {
        return valor;
    }
 
    function simulaMulta( uint256 mesesRestantes, uint256 totalMesesContrato) public view returns(uint256 valorMulta) 
    {
        valorMulta = valor*numeroMaximoLegalDeAlugueisParaMulta;
        valorMulta = valorMulta/totalMesesContrato;
        valorMulta = valorMulta*mesesRestantes;
        return valorMulta;
    } 
        
    function reajustaAluguel(uint256 percentualReajuste) public 
    {
        if (percentualReajuste > 20) {
            percentualReajuste = 20;
        }
        uint256 valorDoAcrescimo = 0;
        valorDoAcrescimo = ((valor*percentualReajuste)/100);
        valor = valor + valorDoAcrescimo;
    }
    
    function aditamentoValorAluguel(uint256 valorCerto) public   {
        valor = valorCerto;
    }

    function aplicaMulta(uint256 mesesRestantes, uint256 percentual) public     {
        require(mesesRestantes<30, "Periodo de contrato invalido");
        for (uint numeroDeVoltas=0; numeroDeVoltas < mesesRestantes; numeroDeVoltas=numeroDeVoltas+2) {
            valor = valor+((valor*percentual)/100);
        }
    }
    
    
    function receberPagamento() public payable {
        require(msg.value>=valor, "Valor insuficiente");
        require(msg.sender == locatarioEndereco, "nova mensagem");
        contaLocador.transfer(msg.value);
        //contaLocatario.transfer(msg.value);
        statusPagamento.push(true);
    }
    
    //msg.value = valor em wei enviado ao contrato
    
    function retornaTexto(uint256 _parametro) public view returns (string memory) {
        if ((valor * _parametro) > 5000) {
            return "Muito caro";
        } else {
            return "Preco razoavel";
        }
    }
    
    function quantosPagamentosJaForamFeitos() public view returns (uint256) {
        return statusPagamento.length;
    }
}
