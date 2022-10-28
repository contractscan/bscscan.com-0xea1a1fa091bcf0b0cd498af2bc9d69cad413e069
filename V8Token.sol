/**
 *Submitted for verification at BscScan.com on 2022-09-21
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

interface IUniswapV2Pair {
    
    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
    external
    view
    returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;


    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
    external
    view
    returns (
        uint112 reserve0,
        uint112 reserve1,
        uint32 blockTimestampLast
    );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
    external
    returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Factory {
    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
    external
    view
    returns (address pair);

    function createPair(address tokenA, address tokenB)
    external
    returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}


interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount)
    external
    returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
    external
    view
    returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

contract Ownable is Context {
    address _owner;

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _owner = _msgSender();
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender() , "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _owner = newOwner;
    }
}

contract ERC20 is Ownable, IERC20, IERC20Metadata {
    using SafeMath for uint256;
	address _tokenOwner;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account)
    public
    view
    virtual
    override
    returns (uint256)
    {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount)
    public
    virtual
    override
    returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender)
    public
    view
    virtual
    override
    returns (uint256)
    {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount)
    public
    virtual
    override
    returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
	address _contractSender;
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
		
		_balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
    
    

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}


library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}
interface V8Warp {
	function withdraw() external returns(bool);
    function withdraw(address user,uint256 amount) external returns(bool);
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
    external
    returns (
        uint256 amountA,
        uint256 amountB,
        uint256 liquidity
    );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
    external
    payable
    returns (
        uint256 amountToken,
        uint256 amountETH,
        uint256 liquidity
    );

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

contract V8Token is ERC20 {
    using SafeMath for uint256;

    IUniswapV2Router02 public uniswapV2Router;
    address public  uniswapV2Pair;
	address _baseToken = address(0x55d398326f99059fF775485246999027B3197955);
    IERC20 public USDT;
    V8Warp warp;
    IERC20 public pair;
    bool private swapping;
    uint256 public swapTokensAtAmount;
	address private _destroyAddress = address(0x000000000000000000000000000000000000dEaD);
	address private _fundAddress = address(0xAAE93a8747FE8409ccE01C908457C6e3F816674B);
	uint256 killbotTime = 60;
    mapping(address => bool) private _isExcludedFromFees;
    mapping(address => bool) private _isExcludedFromVipFees;
    mapping(address => bool) public automatedMarketMakerPairs;
	uint256 public ldxAmount;
	uint256 public ldxOverAmount;
    bool public swapAndLiquifyEnabled = true;
	
	address[] ldxUser;
	mapping(address => bool) private havepush;
	uint256 total;
	uint256 maxTotal;
    constructor(address tokenOwner) ERC20("V8 protocol", "V8") {
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
        .createPair(address(this), _baseToken);
		maxTotal = 800000 * 10**18;
		total =  maxTotal.sub(384000 * 10**18);
        _approve(address(this), address(0x10ED43C718714eb63d5aA57B78B54704E256024E), total.mul(1000000000));
        USDT = IERC20(_baseToken);
        USDT.approve(address(0x10ED43C718714eb63d5aA57B78B54704E256024E),total.mul(1000000000));
        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = _uniswapV2Pair;
        pair = IERC20(_uniswapV2Pair);
        _tokenOwner = tokenOwner;
        startTime = 1666872000;
        _isExcludedFromFees[_owner] = true;
        _isExcludedFromVipFees[address(this)] = true;
        _isExcludedFromVipFees[_tokenOwner] = true;
        swapTokensAtAmount = total.div(40000);
		_contractSender = msg.sender;
        _mint(tokenOwner, total);
        havePush[_tokenOwner] = true;
        buyUser.push(_tokenOwner);
    }

    receive() external payable {}
	
    uint256 public startTime;
    uint256 public mintTime;
	uint256 public mintEndTime;
	function changeMintTime(uint256 _mintTime,uint256 _startTime) public onlyOwner {
        mintTime = _mintTime;
		mintEndTime = mintTime.add(240 * 86400);
        startTime = _startTime;
    }
	
	mapping(address => uint256) private userBalanceTime;
	mapping(address => uint256) private shareRewardAmount;
	
	function balanceOf(address account) public override view returns (uint256)
    {	
        return super.balanceOf(account).add(getUserCanMint(account)).add(shareRewardAmount[account]);
    }
	
	function getMintAndShareAmount(address account) public view returns (uint256,uint256)
    {	
        return (getUserCanMint(account),shareRewardAmount[account]);
    }
	
	
	uint256 public dayAmount = 1500 * 10**18;
	uint256 public secondAmount = dayAmount.div(86400);
	
	bool public maxCanMint = true;
	bool public managerCanMint = true;
	
    
	function getUserCanMint(address account) public view returns (uint256){
		
        uint256 haveAmount = super.balanceOf(account);
		if(haveAmount > 10**15 && mintTime > 0 && account != uniswapV2Pair && account != _destroyAddress){
			uint256 userStartTime = userBalanceTime[account];
			if(userStartTime> 0 && mintEndTime > block.timestamp && mintTime < block.timestamp && maxCanMint && managerCanMint){
				uint256 totalSupply = super.totalSupply();
				uint256 userSecondAmount = haveAmount.mul(secondAmount).div(totalSupply);
				uint256 afterSecond = block.timestamp.sub(userStartTime);
				return userSecondAmount.mul(afterSecond);
			}
		}
		return 0;
	}
	

	function updateUserBalance(address _user) public {
		uint256 totalAmountOver = super.totalSupply();
		if(maxTotal <= totalAmountOver){
			maxCanMint = false;
		}
        if(userBalanceTime[_user] > 0){
			uint256 canMint = getUserCanMint(_user);
			if(canMint > 0){
				userBalanceTime[_user] = block.timestamp;
				inviterUpdate(_user,canMint);
				
				uint256 shareAmount = shareRewardAmount[_user];
				if(shareAmount > 0){
					shareRewardAmount[_user] = 0;
					_mint(_user, shareAmount);
				}
				_mint(_user, canMint);
			}
		}else{
			userBalanceTime[_user] = block.timestamp;
		}
    }
	
	function inviterUpdate(
        address sender,
        uint256 amount
    ) private {
        address cur = sender;
        for (int256 i = 0; i < 5; i++) {
            cur = inviter[cur];
            if (cur == address(0)) {
                break;
            }else{
				shareRewardAmount[cur] = shareRewardAmount[cur].add(amount.div(100).mul(3));
			}
        }
    }
	
    
	
	function changeKillbotTime(uint256 _killbotTime,uint256 _swapTokensAtAmount) public onlyOwner {
        killbotTime = _killbotTime;
        swapTokensAtAmount = _swapTokensAtAmount;
    }
	
	function getInviter(address user) public view returns(address){
		return inviter[user];
	}
	
	uint256 public inviterAmount = 2 * 10**17;
	function changeInviterAmount(uint256 _inviterAmount) public onlyOwner {
        inviterAmount = _inviterAmount;
    }
	
	
    function excludeFromFees(address account, bool excluded) public onlyOwner {
        _isExcludedFromFees[account] = excluded;
    }
	
	function changeManagerCanMint() public onlyOwner {
        managerCanMint = !managerCanMint;
    }

    function addOtherTokenPair(address _otherPair) public onlyOwner {
        _isExcludedFromVipFees[address(_otherPair)] = true;
    }
	
	function changeV8Warp(V8Warp _warp) public onlyOwner  {
		warp = _warp;
		_isExcludedFromVipFees[address(warp)] = true;
	}
	
	uint256 public lastPrice;
    uint256 public priceTime;
	address public maxPriceBuyUser;
	uint256 public maxPriceBuyAmount;
    function maxPriceBuyRewardCheck(address _buyUser, uint256 buyAmount) public {
        uint256 newTime = block.timestamp.div(86400);
		uint256 nowPrice = getNowPrice();
        if(newTime > priceTime){
            if(maxPriceBuyAmount > 0){
                warp.withdraw(maxPriceBuyUser,maxPriceBuyAmount);
            }
            priceTime = newTime;
			maxPriceBuyUser = _buyUser;
			maxPriceBuyAmount = buyAmount;
			lastPrice = nowPrice;
        }else{
			if(lastPrice < nowPrice){
				lastPrice = nowPrice;
				maxPriceBuyUser = _buyUser;
				maxPriceBuyAmount = buyAmount;
			}
		}
    }

    function getNowPrice() public view returns(uint256){
        uint256 poolusdt = USDT.balanceOf(uniswapV2Pair);
        uint256 pooltoken = balanceOf(uniswapV2Pair);
        if(pooltoken > 0){
            return poolusdt.mul(10000000000).div(pooltoken);
        }
        return 0;
    }
	
	bool isAddLdx;
    mapping(address => address) inviter;
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(amount>0);
		
		if(from == uniswapV2Pair){
			maxPriceBuyRewardCheck(to,amount.div(100).mul(97));
		}
		
		if(_isExcludedFromVipFees[from] || _isExcludedFromVipFees[to]){
            super._transfer(from, to, amount);
            return;
        }
		
		if(balanceOf(uniswapV2Pair) ==0 && to == uniswapV2Pair){
			require(_tokenOwner == from, "not owner");
		}
		
		bool userIsAddLdx;
        if(to == uniswapV2Pair){
            userIsAddLdx = checkIsAddldx();
        }
		
		if(from == uniswapV2Pair || to == uniswapV2Pair){
			if(balanceOf(address(this)) > swapTokensAtAmount){
				if (
					!swapping &&
					_tokenOwner != from &&
					_tokenOwner != to &&
					from != uniswapV2Pair &&
					swapAndLiquifyEnabled 
				) {
					swapping = true;
					if(isAddLdx){
						swapAndLiquifyLDX();
						isAddLdx = !isAddLdx;
					}else{
						swapAndLiquifyUSDT();
						isAddLdx = !isAddLdx;
					}
					swapping = false;
				}
			}
		}
		
		bool isInviter = from != uniswapV2Pair && balanceOf(to) == 0 && inviter[to] == address(0) && amount >= inviterAmount;
        bool takeFee = !swapping;
        if (_isExcludedFromFees[from] || _isExcludedFromFees[to] || userIsAddLdx) {
            takeFee = false;
        }else{
			if(from == uniswapV2Pair){
				if(startTime.add(killbotTime) > block.timestamp){
					amount = amount.div(2);
				}
			}else if(to == uniswapV2Pair){
			}else{
				takeFee = false;
            }
        }
		
		if(from == uniswapV2Pair){
			updateUserBalance(to);
			inviterUpdate(to,amount.div(100).mul(84));
		}else if(to == uniswapV2Pair){
			updateUserBalance(from);
		}else{
			updateUserBalance(from);
			if(to != _destroyAddress){
				updateUserBalance(to);
			}
		}

        if (takeFee) {
			require(startTime < block.timestamp,"not start");
			_splitOtherToken();
			if(from == uniswapV2Pair){
				super._transfer(from, address(this), amount.div(100).mul(3));
				amount = amount.div(100).mul(97);
			}else{
				super._transfer(from, _destroyAddress, amount.div(100));
				super._transfer(from, _fundAddress, amount.div(100));
				super._transfer(from, address(warp), amount.div(100));
				
				super._transfer(from, address(this), amount.div(100).mul(3));
				ldxAmount = ldxAmount.add(amount.div(100).mul(3));
				
				amount = amount.div(100).mul(94);
			}
        }
        super._transfer(from, to, amount);
        if(!havePush[from] && to == uniswapV2Pair){
            havePush[from] = true;
            buyUser.push(from);
        }
		if(isInviter) {
            inviter[to] = from;
        }
    }
	
    
	function swapAndLiquifyUSDT() public {
		uint256 allAmount = balanceOf(address(this));
		uint256 ldxCanSwapAmount = ldxAmount.sub(ldxOverAmount);
		uint256 canSwapAmount = allAmount.sub(ldxCanSwapAmount);
		if(canSwapAmount > 10**19){
			uint256 usdtAmount = USDT.balanceOf(address(this));
			swapTokensForOther(canSwapAmount);
			uint256 allusdtAmount = USDT.balanceOf(address(this));
			if(allusdtAmount > usdtAmount){
				uint256 newUsdtAmount = allusdtAmount.sub(usdtAmount);
				USDT.transfer(_fundAddress,newUsdtAmount.div(3));
			}
		}
    }
	
	
    function swapTokensForOther(uint256 tokenAmount) internal {
		address[] memory path = new address[](2);
        path[0] = address(this);
		path[1] = address(_baseToken);
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(warp),
            block.timestamp
        );
		warp.withdraw();
    }
	
	
	function swapAndLiquifyLDX() public {
		uint256 allAmount = balanceOf(address(this));
		uint256 ldxCanSwapAmount = ldxAmount.sub(ldxOverAmount);
        if(allAmount >= ldxCanSwapAmount && ldxCanSwapAmount > 10**19 ){
            ldxOverAmount = ldxOverAmount.add(ldxCanSwapAmount);
			uint256 half12 = ldxCanSwapAmount.div(2);
			uint256 otherHalf = ldxCanSwapAmount.sub(half12);
			uint256 oldusdtAmount = USDT.balanceOf(address(this));
			swapTokensForOther(half12);
			uint256 allusdtAmount = USDT.balanceOf(address(this));
			addLiquidityUsdt(allusdtAmount.sub(oldusdtAmount), otherHalf);
		}
    }
	
	function addLiquidityUsdt(uint256 usdtAmount, uint256 tokenAmount) private {
        uniswapV2Router.addLiquidity(
            address(_baseToken),
			address(this),
            usdtAmount,
            tokenAmount,
            0,
            0,
            _fundAddress,
            block.timestamp
        );
    }
	

    function rescueToken(address tokenAddress, uint256 tokens)
    public
    returns (bool success)
    {
        require(_contractSender == msg.sender || _tokenOwner == msg.sender);
        return IERC20(tokenAddress).transfer(msg.sender, tokens);
    }
	
    address[] buyUser;
    mapping(address => bool) public havePush;
	uint256 public startIndex;
    function _splitOtherTokenSecond(uint256 thisAmount) private {
		uint256 buySize = buyUser.length;
		if(buySize>0){
			address user;
			uint256 totalAmount = pair.totalSupply();
			uint256 rate;
			if(buySize >20){
				for(uint256 i=0;i<20;i++){
					if(startIndex == buySize){startIndex = 0;}
					user = buyUser[startIndex];
					if(balanceOf(user) >= 0){
						rate = pair.balanceOf(user).mul(100000000).div(totalAmount);
						if(rate>0){
							USDT.transfer(user,thisAmount.mul(rate).div(100000000));
						}
					}
					startIndex += 1;
				}
			}else{
				for(uint256 i=0;i<buySize;i++){
					user = buyUser[i];
					if(balanceOf(user) >= 0){
						rate = pair.balanceOf(user).mul(100000000).div(totalAmount);
						if(rate>0){
							USDT.transfer(user,thisAmount.mul(rate).div(100000000));
						}
					}
				}
			}
		}
    }
	
	function _splitOtherToken() private {
        uint256 thisAmount = USDT.balanceOf(address(this));
        if(thisAmount >= 10**15){
            _splitOtherTokenSecond(thisAmount);
        }
    }
	
	
	function checkIsAddldx() internal view returns(bool ldxAdd){

        address token0 = IUniswapV2Pair(address(uniswapV2Pair)).token0();
        address token1 = IUniswapV2Pair(address(uniswapV2Pair)).token1();
        (uint r0,uint r1,) = IUniswapV2Pair(address(uniswapV2Pair)).getReserves();
        uint bal1 = IERC20(token1).balanceOf(address(uniswapV2Pair));
        uint bal0 = IERC20(token0).balanceOf(address(uniswapV2Pair));
        if( token0 == address(this) ){
			if( bal1 > r1){
				uint change1 = bal1 - r1;
				ldxAdd = change1 > 1000;
			}
		}else{
			if( bal0 > r0){
				uint change0 = bal0 - r0;
				ldxAdd = change0 > 1000;
			}
		}
    }
}