package main

import (
	contract "Contract/task"
	"fmt"
)

func main() {
	// fmt.Println("Hello, Go!")
	i := contract.RomanToInt("XIV")
	// s := contract.IntToRoman(90)
	fmt.Println(i)
}
