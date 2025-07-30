package task2

import (
	"context"
	"fmt"
	"log"
	"math/big"

	"github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/ethclient"
)

// 事件签名
var (
	TransferEventSignature = crypto.Keccak256Hash([]byte("Transfer(address,address,uint256)"))
	ApprovalEventSignature = crypto.Keccak256Hash([]byte("Approval(address,address,uint256)"))
	MintEventSignature     = crypto.Keccak256Hash([]byte("Mint(address,uint256)"))
)

// 监听事件方法
func CatchEvent() {
	// 连接到 geth 节点
	client, err := ethclient.Dial("wss://ethereum-sepolia-rpc.publicnode.com")
	if err != nil {
		log.Fatal(err)
	}

	// 合约地址
	contractAddress := common.HexToAddress("0xD10732dE614f0ecB33a66fAa8c6dEec983CBD448")

	// 创建事件过滤器
	query := ethereum.FilterQuery{
		Addresses: []common.Address{contractAddress},
		FromBlock: big.NewInt(0), // latest
		ToBlock:   nil,           // latest
		Topics: [][]common.Hash{
			{
				TransferEventSignature,
				ApprovalEventSignature,
				MintEventSignature,
			},
		},
	}

	// 监听事件
	logs := make(chan types.Log)
	sub, err := client.SubscribeFilterLogs(context.Background(), query, logs)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("开始监听合约事件...")

	for {
		select {
		case err := <-sub.Err():
			log.Fatal(err)
		case vLog := <-logs:
			handleEvent(client, vLog)
		}
	}
}

func handleEvent(client *ethclient.Client, vLog types.Log) {
	switch vLog.Topics[0] {
	case TransferEventSignature:
		handleTransferEvent(vLog)
	case ApprovalEventSignature:
		handleApprovalEvent(vLog)
	case MintEventSignature:
		handleMintEvent(vLog)
	}
}

func handleTransferEvent(vLog types.Log) {
	// 解析 Transfer 事件
	from := common.HexToAddress(vLog.Topics[1].Hex())
	to := common.HexToAddress(vLog.Topics[2].Hex())
	value := new(big.Int).SetBytes(vLog.Data)

	fmt.Printf("Transfer Event:\n")
	fmt.Printf("From: %s\n", from.Hex())
	fmt.Printf("To: %s\n", to.Hex())
	fmt.Printf("Value: %s\n", value.String())
	fmt.Printf("Transaction Hash: %s\n", vLog.TxHash.Hex())
	fmt.Println("---")
}

func handleApprovalEvent(vLog types.Log) {
	// 解析 Approval 事件
	owner := common.HexToAddress(vLog.Topics[1].Hex())
	spender := common.HexToAddress(vLog.Topics[2].Hex())
	value := new(big.Int).SetBytes(vLog.Data)

	fmt.Printf("Approval Event:\n")
	fmt.Printf("Owner: %s\n", owner.Hex())
	fmt.Printf("Spender: %s\n", spender.Hex())
	fmt.Printf("Value: %s\n", value.String())
	fmt.Printf("Transaction Hash: %s\n", vLog.TxHash.Hex())
	fmt.Println("---")
}

func handleMintEvent(vLog types.Log) {
	// 解析 Mint 事件
	to := common.HexToAddress(vLog.Topics[1].Hex())
	amount := new(big.Int).SetBytes(vLog.Data)

	fmt.Printf("Mint Event:\n")
	fmt.Printf("To: %s\n", to.Hex())
	fmt.Printf("Amount: %s\n", amount.String())
	fmt.Printf("Transaction Hash: %s\n", vLog.TxHash.Hex())
	fmt.Println("---")
}
