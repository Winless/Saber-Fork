import {TokenExchange} from '../generated/StableSwapPool/StableSwapPool'
import {ExchangeEntity, Token} from '../generated/schema'
import {BigInt} from "@graphprotocol/graph-ts";
import {convertTokenToDecimal, ZERO_BD} from "./utils";
import {
    tokenUSDC_decimals,
    tokenUSDC_id,
    tokenUSDC_symbol,
    tokenUSDT_decimals,
    tokenUSDT_id,
    tokenUSDT_symbol
} from "./token";


export function handleUSDC2USDT(event: TokenExchange): void {
    let id = event.address.toHex()
    let entity = ExchangeEntity.load(id)
    if (entity == null) {
        let token0 = Token.load(tokenUSDC_id)
        if (token0 == null) {
            token0 = new Token(tokenUSDC_id)
            token0.decimals = tokenUSDC_decimals
            token0.symbol = tokenUSDC_symbol
            token0.save()
        }
        let token1 = Token.load(tokenUSDT_id)
        if (token1 == null) {
            token1 = new Token(tokenUSDT_id)
            token1.decimals = tokenUSDT_decimals
            token1.symbol = tokenUSDT_symbol
            token1.save()
        }
        entity = new ExchangeEntity(id)
        entity.token0 = token0.id
        entity.token1 = token1.id
        entity.token0BoughtTokenAmount = ZERO_BD
        entity.token0SoldTokenAmount = ZERO_BD
        entity.token1BoughtTokenAmount = ZERO_BD
        entity.token1SoldTokenAmount = ZERO_BD
    }
    let token0 = Token.load(tokenUSDC_id)
    let token1 = Token.load(tokenUSDT_id)
    if (event.params.bought_id == BigInt.fromString("0")) {
        let buyAmount = convertTokenToDecimal(event.params.tokens_bought, token0.decimals)
        let soldAmount = convertTokenToDecimal(event.params.tokens_sold, token1.decimals)
        entity.token0BoughtTokenAmount = entity.token0BoughtTokenAmount.plus(buyAmount)
        entity.token1SoldTokenAmount = entity.token1SoldTokenAmount.plus(soldAmount)
    } else {
        let buyAmount = convertTokenToDecimal(event.params.tokens_bought, token1.decimals)
        let soldAmount = convertTokenToDecimal(event.params.tokens_sold, token0.decimals)
        entity.token1BoughtTokenAmount = entity.token1BoughtTokenAmount.plus(buyAmount)
        entity.token0SoldTokenAmount = entity.token0SoldTokenAmount.plus(soldAmount)
    }
    entity.block = event.block.number
    entity.timestamp = event.block.timestamp
    entity.save()
}
