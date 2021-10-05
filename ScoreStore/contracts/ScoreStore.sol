pragma solidity >=0.5.0 <0.7.0;

contract ScoreStore
{
    mapping (string => int) PersonScores;

    function AddPersonScore(string memory name, int score) public
    {
        PersonScores[name] = score;
    }

    function GetScore(string memory name) public returns (int)
    {
        return PersonScores[name];
    }
}