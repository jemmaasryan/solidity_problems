//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;
/** @title Integral and derivative calculator. */
contract Problem8 {
    /** @dev Calculates definite integral.
      * @param lowerBound Lower bound of the given function.
      * @param upperBound Upper bound of the given function.
      * @param _function  Given polynomial function.
      * @return result    Result of the integral.
      */
    function calculateIntegral(uint256 lowerBound, uint256 upperBound, uint256[] memory _function) public pure returns(uint256 result){
        uint256  upper;
        uint256  lower;
        for(uint256 i = 0; i < _function.length; i++) {
            upper += ((_function[i] / (i+1)) * (upperBound ** (i+1)));
        }
        for(uint256 j = 0; j < _function.length; j++){
            lower += ((_function[j] / (j+1)) * (lowerBound ** (j+1)));
        }
        result = upper - lower;
    }
    /** @dev Calculates derivative of the function at a given point.
      * @param _function  Given polynomial function.
      * @param point      Given point.
      * @return result    Result of the derivative at a specific point.
      */
    function calculateDerivative(uint256[] memory _function, uint256 point) public pure returns(uint256 result) {
        for(uint256 i = 1; i < _function.length; i++) {
            result += _function[i] * i * (point ** (i-1));
        }
    }
}
