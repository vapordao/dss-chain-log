pragma solidity ^0.6.7;

contract ChainLogFab {

    ChainLog chainLog;

    constructor() public {
        chainLog = new ChainLog{salt: bytes32("MCD CHANGELOG")}();
        chainLog.rely(msg.sender);
    }

    function getChainLog() public view returns (address) {
        return address(chainLog);
    }
}

contract ChainLog {

    event Rely(address usr);
    event Deny(address usr);
    event Update(bytes32 key, address addr);

    // --- Auth ---
    mapping (address => uint) public wards;
    function rely(address usr) external auth { wards[usr] = 1; emit Rely(usr); }
    function deny(address usr) external auth { wards[usr] = 0; emit Deny(usr); }
    modifier auth {
        require(wards[msg.sender] == 1, "ChainLog/not-authorized");
        _;
    }

    bytes32 public version;

    mapping (bytes32 => address) public addr;

    constructor() public {
        version = bytes32("0.0.0");
        addr["CHANGELOG"] = address(this);
        wards[msg.sender] = 1;
    }

    function setVersion(bytes32 _version) public auth {
        version = _version;
    }

    function setAddress(bytes32 _key, address _addr) public auth {
        addr[_key] = _addr;
    }
}
