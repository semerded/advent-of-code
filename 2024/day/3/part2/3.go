package main

import (
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
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
	const mulPattern string = `(mul\(\d{1,3},\d{1,3}\))|(don't\(\))|(do\(\))`
	const numPattern string = `\d{1,3}`
	var result int = 0
	var mulEnabled bool = true

	matches := getRegexpMatches(str, mulPattern)
	println(len(matches))

	for _, match := range matches {
		if strings.Contains(match, "do()") {
			mulEnabled = true
		} else if strings.Contains(match, "don't()") {
			mulEnabled = false
		} else if mulEnabled {
			result += getMulFromMulFunc(match, numPattern)
		}
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
