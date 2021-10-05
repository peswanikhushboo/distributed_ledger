pragma solidity >=0.4.22 <0.9.0;

contract PropertyTransfer {
    address public developmentAuthority;
    uint public totalNoOfProperty;

    function propertyTransfer() public{
        developmentAuthority = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == developmentAuthority);
        _;
    }

    struct Property {
        string name;
        bool isSold;
    }

    mapping(address=>mapping(uint256=>Property)) public propertiesOwner;
    mapping(address=>uint256) individualCountOfPropertyPerOwner;

    event PropertyAlloted (address indexed _verifiedOwner, uint256 indexed _totalNoOfPropertyCurrentlyOwned, string _propertyName, string _msg);
    event PropertyTransferred ( address indexed _from, address indexed _to, string _propertyName, string _message);

    function getPropertyCountOfAnyAddress(address _ownerAddress) public view returns(uint256)
    {
        uint count = 0;
        for(uint i=0; i< individualCountOfPropertyPerOwner[_ownerAddress]; i++)
        {
            if(propertiesOwner[_ownerAddress][i].isSold != true)
            {
                count++;

            }
            return count;
        }

    }

    function allotProperty(address _verifiedOwner, string memory _propertyName) public onlyOwner 
    {
        propertiesOwner[_verifiedOwner][individualCountOfPropertyPerOwner[_verifiedOwner]++].name = _propertyName;
        totalNoOfProperty++;

        //emit PropertyAlloted(_verifiedOwner, individualCountOfPropertyPerOwner[_verifiedOwner], _propertyName, "Property Alloted successfully");   
    }

    function isOwner(address _checkOwnerAddress, string memory _propertyName) public returns(uint)
    {

        uint i;
        bool flag;
        for (i=0; i < individualCountOfPropertyPerOwner[_checkOwnerAddress]; i++)
        {
            if(propertiesOwner[_checkOwnerAddress][i].isSold == true)
            {
                break;
            }
            flag = stringEquals(propertiesOwner[_checkOwnerAddress][i].name, _propertyName);
            if(flag == true)
            {
                break;
            }
        }
        if(flag == true)
        {
            return i;
        }
        else
        {
            return 99999;
        }
        
    }

    function stringEquals(string memory s1, string memory s2) public returns(bool)
    {
        return (keccak256(abi.encodePacked((s1))) == keccak256(abi.encodePacked((s2))));
    }

    function transferProperty(address _to, string memory _propertyName) public returns (bool, uint)
    {
        uint256 checkOwner = isOwner(msg.sender, _propertyName);
        bool flag;
        if(checkOwner != 99999 && propertiesOwner[msg.sender][checkOwner].isSold == false)
        {
            propertiesOwner[msg.sender][checkOwner].isSold = true;
            propertiesOwner[msg.sender][checkOwner].name = "Sold";


            propertiesOwner[_to][individualCountOfPropertyPerOwner[_to]++].name = _propertyName;

            flag = true;
            emit PropertyTransferred(msg.sender, _to, _propertyName, "Owner has been changed");
        }
        else{
            flag = false;
            emit PropertyTransferred(msg.sender, _to, _propertyName, "Owner doesnt own the property ");
        }

        return(flag, checkOwner);
    }

}