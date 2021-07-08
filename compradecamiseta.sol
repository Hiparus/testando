// SPDX-License-Identifier: CC-BY-4.0
pragma solidity ^0.8.4;

contract compraEVendaDeCamisetas {
    string public vendedor;
    address payable contaDaLoja;

    constructor() {
        vendedor = "Guilherme Augusto Navarro Sobral Pagliarini de Almeida - LTDA";
        owner = msg.sender;
    }

    modifier somenteLoja {
        require(msg.sender == owner, "Somente a loja pode realizar essa operacao");
        _;
    }    

    struct Encomenda {
        string comprador;
        string cor;
        string tamanho;
        uint cep;
        string bairro;
        string ruaENumero;
        string complemento;
    }

    address public owner;

    Encomenda[] private pedidos;

    function registrarPedido(
        string memory paramComprador,
        string memory paramCor,
        string memory paramTamanho,
        uint paramCEP,
        string memory paramBairro,
        string memory paramRuaENumero,
        string memory paramComplemento
    ) external returns (bool) {
        Encomenda memory novoPedido = Encomenda(paramComprador, paramCor, paramTamanho, paramCEP, paramBairro, paramRuaENumero, paramComplemento);
        pedidos.push(novoPedido);
        return true;
    }
    
    function conferirPedidos(uint256 numeroDoPedido) external view returns (Encomenda memory) {
        if (msg.sender == owner) {
            return pedidos[numeroDoPedido];
        } if(msg.sender != owner) {
            revert();
        }
    }

    function verificarValorPelaCor(uint categoriaDaCor)
    public 
    pure 
    returns (uint valorPelaCor) {
        if (categoriaDaCor == 5) {
            return 160;
        }
        // A camiseta chumbo rajada é a mais cara.
        if (categoriaDaCor == 4) {
            return 140;
        }
        // A camiseta roxa é a segunda mais cara.
        if (categoriaDaCor == 3) {
            return 130;
        }
        // A camiseta preta é a média.
        if (categoriaDaCor == 2) {
            return 120;
        }
        // A camiseta azul-marinho é a segunda mais barata.
        if (categoriaDaCor == 1) {
            return 100;
        }
        // A camiseta branca é a mais em conta.
    } 
    // Todos os valores acima são em R$, sendo necessária a conversão em Ether no dia do pagamento.
    

    function verificarPercentualPeloTamanho(uint categoriaTamanho)
    public 
    pure
    returns (uint percentualPeloTamanho) {
        if (categoriaTamanho == 5) {
            return 150;
        }
        // O tamanho GG é o mais caro.
        if (categoriaTamanho == 4) {
            return 135;
        }
        // O tamanho G é o segundo mais caro.
        if (categoriaTamanho == 3) {
            return 125;
        }
        // O tamanho M é o preço médio.
        if (categoriaTamanho == 2) {
            return 110;
        }
        // O tamanho P é o segundo mais em conta.
        if (categoriaTamanho == 1) {
            return 100;
        }
        // O tamanho PP é o mais em conta.
    } 

    function calcularValorDaCamiseta(uint valorPelaCor, uint percentualPeloTamanho)
    public
    pure
    returns(uint valorDaCamiseta) {
        return valorPelaCor * percentualPeloTamanho / 100;
    }

    mapping(address => uint) pagamentos;
    
    event deposito(address emissario, uint valor, uint saldo);
    event retirada(uint quantidade, uint saldo);
    event transferencia(address destinatario, uint quantidade, uint saldo);
    
    function depositar() public payable {
        emit deposito(msg.sender, msg.value, address(this).balance);
            if(msg.value < 1 wei) {
            // O valor aqui é meramente exemplificativo, a loja teria que fazer o cálculo para o valor exato das camisetas em Ether e atualizar acompanhando seu valor de mercado.
            revert();
        }
    }

    function retirar(uint _quantidade) public payable somenteLoja{
        contaDaLoja.transfer(_quantidade);
        emit retirada(_quantidade, address(this).balance);
    }
    
    function transfer(address payable _destinatario, uint _quantidade) public somenteLoja{
        _destinatario.transfer(_quantidade);
        emit transferencia(_destinatario, _quantidade, address(this).balance);
    }
    
    function verificarSaldo() public view returns (uint) {
        return address(this).balance;
    }
    
}
