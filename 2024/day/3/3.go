package main

import (
	"fmt"
	"os"
	"regexp"
	"strconv"
)

const stringPath string = "day/3/3.txt"

func main() {
	str, err := getString(stringPath)
	if err != nil {
		panic(err)
	}
	fmt.Println("Result from corrupted string:", GetMulResultFromCorruptedString(str))
}

func GetMulResultFromCorruptedString(str string) int {
	const mulPattern string = `mul\(\d{1,3},\d{1,3}\)`
	const numPattern string = `\d{1,3}`
	var result int = 0

	mulMatches := getRegexpMatches(str, mulPattern)

	for _, mul := range mulMatches {
		result += getMulFromMulFunc(mul, numPattern)
	}

	return result
}

func getRegexpMatches(str string, pattern string) []string {

	regex, err := regexp.Compile(pattern)
	if err != nil {
		panic(err)
	}
	return regex.FindAllString(str, -1)
}

func getMulFromMulFunc(mul string, pattern string) int {
	numbers := getRegexpMatches(mul, pattern)
	num1, err := strconv.Atoi(numbers[0])
	if err != nil {
		fmt.Println("num1 error", numbers[0])
		panic(err)
	}
	num2, err := strconv.Atoi(numbers[1])
	if err != nil {
		fmt.Println("num1 error", numbers[0])
		panic(err)
	}
	return num1 * num2
}

func getString(path string) (string, error) {
	str, err := os.ReadFile(path)
	return string(str), err
}
