// THIS IS AN AUTOGENERATED FILE. DO NOT EDIT THIS FILE DIRECTLY.

import {
  TypedMap,
  Entity,
  Value,
  ValueKind,
  store,
  Address,
  Bytes,
  BigInt,
  BigDecimal
} from "@graphprotocol/graph-ts";

export class Token extends Entity {
  constructor(id: string) {
    super();
    this.set("id", Value.fromString(id));
  }

  save(): void {
    let id = this.get("id");
    assert(id !== null, "Cannot save Token entity without an ID");
    assert(
      id.kind == ValueKind.STRING,
      "Cannot save Token entity with non-string ID. " +
        'Considering using .toHex() to convert the "id" to a string.'
    );
    store.set("Token", id.toString(), this);
  }

  static load(id: string): Token | null {
    return store.get("Token", id) as Token | null;
  }

  get id(): string {
    let value = this.get("id");
    return value.toString();
  }

  set id(value: string) {
    this.set("id", Value.fromString(value));
  }

  get symbol(): string {
    let value = this.get("symbol");
    return value.toString();
  }

  set symbol(value: string) {
    this.set("symbol", Value.fromString(value));
  }

  get decimals(): BigInt {
    let value = this.get("decimals");
    return value.toBigInt();
  }

  set decimals(value: BigInt) {
    this.set("decimals", Value.fromBigInt(value));
  }
}

export class ExchangeEntity extends Entity {
  constructor(id: string) {
    super();
    this.set("id", Value.fromString(id));
  }

  save(): void {
    let id = this.get("id");
    assert(id !== null, "Cannot save ExchangeEntity entity without an ID");
    assert(
      id.kind == ValueKind.STRING,
      "Cannot save ExchangeEntity entity with non-string ID. " +
        'Considering using .toHex() to convert the "id" to a string.'
    );
    store.set("ExchangeEntity", id.toString(), this);
  }

  static load(id: string): ExchangeEntity | null {
    return store.get("ExchangeEntity", id) as ExchangeEntity | null;
  }

  get id(): string {
    let value = this.get("id");
    return value.toString();
  }

  set id(value: string) {
    this.set("id", Value.fromString(value));
  }

  get token0(): string {
    let value = this.get("token0");
    return value.toString();
  }

  set token0(value: string) {
    this.set("token0", Value.fromString(value));
  }

  get token1(): string {
    let value = this.get("token1");
    return value.toString();
  }

  set token1(value: string) {
    this.set("token1", Value.fromString(value));
  }

  get token0SoldTokenAmount(): BigDecimal {
    let value = this.get("token0SoldTokenAmount");
    return value.toBigDecimal();
  }

  set token0SoldTokenAmount(value: BigDecimal) {
    this.set("token0SoldTokenAmount", Value.fromBigDecimal(value));
  }

  get token0BoughtTokenAmount(): BigDecimal {
    let value = this.get("token0BoughtTokenAmount");
    return value.toBigDecimal();
  }

  set token0BoughtTokenAmount(value: BigDecimal) {
    this.set("token0BoughtTokenAmount", Value.fromBigDecimal(value));
  }

  get token1SoldTokenAmount(): BigDecimal {
    let value = this.get("token1SoldTokenAmount");
    return value.toBigDecimal();
  }

  set token1SoldTokenAmount(value: BigDecimal) {
    this.set("token1SoldTokenAmount", Value.fromBigDecimal(value));
  }

  get token1BoughtTokenAmount(): BigDecimal {
    let value = this.get("token1BoughtTokenAmount");
    return value.toBigDecimal();
  }

  set token1BoughtTokenAmount(value: BigDecimal) {
    this.set("token1BoughtTokenAmount", Value.fromBigDecimal(value));
  }

  get timestamp(): BigInt {
    let value = this.get("timestamp");
    return value.toBigInt();
  }

  set timestamp(value: BigInt) {
    this.set("timestamp", Value.fromBigInt(value));
  }

  get block(): BigInt {
    let value = this.get("block");
    return value.toBigInt();
  }

  set block(value: BigInt) {
    this.set("block", Value.fromBigInt(value));
  }
}

export class AddRewardEntity extends Entity {
  constructor(id: string) {
    super();
    this.set("id", Value.fromString(id));
  }

  save(): void {
    let id = this.get("id");
    assert(id !== null, "Cannot save AddRewardEntity entity without an ID");
    assert(
      id.kind == ValueKind.STRING,
      "Cannot save AddRewardEntity entity with non-string ID. " +
        'Considering using .toHex() to convert the "id" to a string.'
    );
    store.set("AddRewardEntity", id.toString(), this);
  }

  static load(id: string): AddRewardEntity | null {
    return store.get("AddRewardEntity", id) as AddRewardEntity | null;
  }

  get id(): string {
    let value = this.get("id");
    return value.toString();
  }

  set id(value: string) {
    this.set("id", Value.fromString(value));
  }

  get amount(): BigInt {
    let value = this.get("amount");
    return value.toBigInt();
  }

  set amount(value: BigInt) {
    this.set("amount", Value.fromBigInt(value));
  }

  get duration(): BigInt {
    let value = this.get("duration");
    return value.toBigInt();
  }

  set duration(value: BigInt) {
    this.set("duration", Value.fromBigInt(value));
  }

  get timestamp(): BigInt {
    let value = this.get("timestamp");
    return value.toBigInt();
  }

  set timestamp(value: BigInt) {
    this.set("timestamp", Value.fromBigInt(value));
  }

  get block(): BigInt {
    let value = this.get("block");
    return value.toBigInt();
  }

  set block(value: BigInt) {
    this.set("block", Value.fromBigInt(value));
  }
}
