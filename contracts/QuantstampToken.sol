// Quantstamp Technologies Inc. (info@quantstamp.com)

pragma solidity ^0.4.15;

import './token/StandardToken.sol';
import './token/BurnableToken.sol';
import './ownership/Ownable.sol';
import './math/SafeMath.sol';

/**
 * The Quantstamp token (QSP) has a fixed supply and restricts the ability
 * to transfer tokens until the owner has called the enableTransfer()
 * function.
 *
 * The owner can associate the token with a token sale contract. In that
 * case, the token balance is moved to the token sale contract, which
 * in turn can transfer its tokens to contributors to the sale.
 */
contract QuantstampToken is StandardToken, BurnableToken, Ownable {

    // Constants
    string public constant name = "Quantstamp Token";
    string public constant symbol = "QSP";
    uint8 public constant decimals = 18;
    uint256 public constant INITIAL_SUPPLY   = 1000000000 * (10 ** uint256(decimals));
    uint256 public constant CROWDSALE_SUPPLY =  650000000 * (10 ** uint256(decimals));

    // Properties
    uint256 public crowdSaleSupply;         // the number of tokens available for crowdsales
    bool public transferEnabled = false;    // indicates if transferring tokens is enabled or not
    address crowdSaleAddr;                  // the address of a crowdsale currently selling this token


    // Modifiers
    modifier onlyWhenTransferEnabled() {
        if (!transferEnabled) {
            require(msg.sender == owner || msg.sender == crowdSaleAddr);
        }
        _;
    }

    /**
     * Constructor - instantiates token supply and allocates balanace of
     * to the owner (msg.sender).
     */
    function QuantstampToken() {
        totalSupply = INITIAL_SUPPLY;
        crowdSaleSupply = CROWDSALE_SUPPLY;
        balances[msg.sender] = totalSupply; // owner initially has all tokens
        assert(CROWDSALE_SUPPLY <= INITIAL_SUPPLY);
    }

    /**
     * Associates this token with a current crowdsale, giving the crowdsale
     * an allowance of tokens from the crowdsale supply. This gives the
     * crowdsale the ability to call transferFrom to transfer tokens to
     * whomever has purchased them.
     *
     * Note that if _amountForSale is 0, then it is assumed that the full
     * remaining crowdsale supply is made available to the crowdsale.
     *
     * @param _crowdSaleAddr The address of a crowdsale contract that will sell this token
     * @param _amountForSale The supply of tokens provided to the crowdsale
     */
    function setCrowdsale(address _crowdSaleAddr, uint256 _amountForSale) external onlyOwner {
        require(!transferEnabled);
        require(_amountForSale <= crowdSaleSupply);

        // if 0, then full available crowdsale supply is assumed
        uint amount = (_amountForSale == 0) ? crowdSaleSupply : _amountForSale;

        // Clear allowance of old, and set allowance of new
        approve(crowdSaleAddr, 0);
        approve(_crowdSaleAddr, amount);

        crowdSaleAddr = _crowdSaleAddr;
    }

    /**
     * Enables the ability of anyone to transfer their tokens. This can
     * only be called by the token owner. Once enabled, it is not
     * possible to disable transfers.
     */
    function enableTransfer() external onlyOwner {
        transferEnabled = true;
    }

    /**
     * Overrides ERC20 transfer function with modifier that prevents the
     * ability to transfer tokens until after transfers have been enabled.
     */
    function transfer(address _to, uint256 _value) public onlyWhenTransferEnabled returns (bool) {
        return super.transfer(_to, _value);
    }

    /**
     * Overrides ERC20 transferFrom function with modifier that prevents the
     * ability to transfer tokens until after transfers have been enabled.
     */
    function transferFrom(address _from, address _to, uint256 _value) public onlyWhenTransferEnabled returns (bool) {
        bool result = super.transferFrom(_from, _to, _value);
        if (result && msg.sender == crowdSaleAddr) {
            crowdSaleSupply.sub(_value);
        }
        return result;
    }

    /**
     * Overrides the burn function so that it cannot be called until after
     * transfers have been enabled.
     */
    function burn(uint256 _value) public onlyWhenTransferEnabled {
        super.burn(_value);
    }
}
