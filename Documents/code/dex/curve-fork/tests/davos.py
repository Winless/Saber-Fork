import pytest
from brownie import Token, accounts

@pytest.fixture
def deploy():
    return accounts[0].deploy(Token, 1e9, "Davos", "Davos")

def test_transfer(token):
    token.transfer(accounts[1], "100 ether", {'from': accounts[0]})
    assert token.balanceOf(accounts[0]) == "900 ether"

# def test_name(token):
#     assert token.name() == "AppleToken"

# def test_symbol(token):
#     assert token.symbol() == "APT"

# def test_totalSupply(token):
#     assert token.totalSupply() == "1000 ether"

# def test_approve(token):
#     token.approve(accounts[1],"100 ether",{'from':accounts[0]})
#     assert token.allowance(accounts[0],accounts[1]) == "100 ether"

# def test_burn(token):
#     token.burn("100 ether",{'from':accounts[0]})
#     print("addr=",token.address)
#     assert token.totalSupply() == "900 ether"

# def test_transferFrom(token):
#     token.approve(accounts[1],"100 ether",{'from':accounts[0]})
#     token.transferFrom(accounts[0],accounts[1],"100 ether",{'from':accounts[1]})
#     assert token.balanceOf(accounts[1]) == "100 ether"

# def test_burnFrom(token):
#     token.approve(accounts[1],"100 ether",{'from':accounts[0]})
#     token.burnFrom(accounts[0],"100 ether",{'from':accounts[1]})
#     assert token.totalSupply() == "900 ether"