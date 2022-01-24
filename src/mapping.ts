import {TokenExchange} from '../generated/StableSwapPool/StableSwapPool'
import {ExchangeEntity, Token} from '../generated/schema'
import {BigInt} from "@graphprotocol/graph-ts";
import {convertTokenToDecimal, ZERO_BD, ZERO_BI} from "./utils";


export function handleTokenExchange(event: TokenExchange): void {
    let id = event.address.toHex()
    let entity = ExchangeEntity.load(id)
    let token0 :Token
    let token1:Token
    if (entity == null) {
        token0 = new Token("0x85ed8780eec181b21e1057f840623f1e9e89924e")
        token0.decimals = BigInt.fromString("6")
        token0.symbol = "USDC"
        token0.save()

        token1 = new Token("0x71a4c56f9165f17cd4c940f37b88abd9c19f0f6d")
        token1.decimals = BigInt.fromString("6")
        token1.symbol = "USDT"
        token1.save()
        entity = new ExchangeEntity(id)
        entity.token0 = token0.id
        entity.token1 = token1.id
        entity.token0BoughtTokenAmount = ZERO_BD
        entity.token0SoldTokenAmount = ZERO_BD
        entity.token1BoughtTokenAmount = ZERO_BD
        entity.token1SoldTokenAmount = ZERO_BD
    }
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
