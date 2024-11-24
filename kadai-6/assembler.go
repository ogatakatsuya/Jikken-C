package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

type Instruction struct {
	Opcode  byte
	Operand string
	Size    int
}

var instructionSet = map[string]Instruction{
	"SETIXH": {Opcode: 0xd0, Operand: "Memory", Size: 2},
	"SETIXL": {Opcode: 0xd1, Operand: "Memory", Size: 2},
	"SETIX":  {Opcode: 0xd2, Operand: "Address", Size: 3},
	"LDIA":   {Opcode: 0xd8, Operand: "Immediate", Size: 2},
	"LDIB":   {Opcode: 0xd9, Operand: "Immediate", Size: 2},
	"LDDA":   {Opcode: 0xe0, Operand: "None", Size: 1},
	"LDDB":   {Opcode: 0xe1, Operand: "None", Size: 1},
	"STDA":   {Opcode: 0xf0, Operand: "None", Size: 1},
	"STDB":   {Opcode: 0xf4, Operand: "None", Size: 1},
	"STDI":   {Opcode: 0xf8, Operand: "Immediate", Size: 2},
	"ADDA":   {Opcode: 0x80, Operand: "None", Size: 1},
	"SUBA":   {Opcode: 0x81, Operand: "None", Size: 1},
	"ANDA":   {Opcode: 0x82, Operand: "None", Size: 1},
	"ORA":    {Opcode: 0x83, Operand: "None", Size: 1},
	"NOTA":   {Opcode: 0x84, Operand: "None", Size: 1},
	"INCA":   {Opcode: 0x85, Operand: "None", Size: 1},
	"DECA":   {Opcode: 0x86, Operand: "None", Size: 1},
	"ADDB":   {Opcode: 0x90, Operand: "None", Size: 1},
	"SUBB":   {Opcode: 0x91, Operand: "None", Size: 1},
	"ANDB":   {Opcode: 0x92, Operand: "None", Size: 1},
	"ORB":    {Opcode: 0x93, Operand: "None", Size: 1},
	"NOTB":   {Opcode: 0x98, Operand: "None", Size: 1},
	"INCB":   {Opcode: 0x99, Operand: "None", Size: 1},
	"DECB":   {Opcode: 0x9a, Operand: "None", Size: 1},
	"CMP":    {Opcode: 0xa1, Operand: "None", Size: 1},
	"JP":     {Opcode: 0x60, Operand: "Address", Size: 3},
	"JPC":    {Opcode: 0x40, Operand: "Address", Size: 3},
	"JPZ":    {Opcode: 0x50, Operand: "Address", Size: 3},
	"NOP":    {Opcode: 0x00, Operand: "None", Size: 1},
	// 追加命令
	// "PROGRAM": {Opcode: 0x00, Operand: "None", Size: 1},
	// "END":     {Opcode: 0x00, Operand: "None", Size: 1},
	"DC":  {Opcode: 0x00, Operand: "None", Size: 1},
	"RET": {Opcode: 0x30, Operand: "None", Size: 1},
}

func main() {
	var fileName string

	fmt.Print("ファイル名を入力してください: ")
	fmt.Scan(&fileName)

	inputFilePath := "./input/" + fileName
	outputFilePath := "./output/" + fileName

	inputFile, err := os.Open(inputFilePath)
	if err != nil {
		handleError(err)
		return
	}
	defer inputFile.Close()

	outputFile, err := os.Create(outputFilePath)
	if err != nil {
		handleError(err)
		return
	}
	defer outputFile.Close()

	labelList, err := calculateLabelAddresses(inputFilePath)
	if err != nil {
		handleError(err)
		return
	}

	assembleLine := assemberGenerator(labelList)
	scanner := bufio.NewScanner(inputFile)

	for scanner.Scan() {
		line := scanner.Text()
		memoryList, binaryList, err := assembleLine(line)
		if err != nil {
			handleError(err)
			continue
		}
		for i := 0; i < len(memoryList); i++ {
			outputFile.WriteString(memoryList[i] + "\t" + binaryList[i] + "\n")
		}
	}

	if err := scanner.Err(); err != nil {
		handleError(err)
		return
	}
}

func handleError(err error) {
	if err != nil {
		fmt.Println("Error! Detail:", err)
	}
}

func assemberGenerator(labelList map[string]string) func(string) ([]string, []string, error) {
	memoryAddress := 0x0000
	labelAddresses := labelList
	return func(line string) ([]string, []string, error) {
		var (
			memory []string
			binary []string
		)
		parts := strings.Fields(line)
		if len(parts) == 0 {
			return nil, nil, fmt.Errorf("空行です")
		}

		opcodeStr := parts[0]
		instr, ok := instructionSet[opcodeStr]

		// ラベル or 登録していない命令の場合
		if !ok {
			if opcodeStr == "PROGRAM" || opcodeStr == "END" {
				return nil, nil, nil
			}
			instr, ok = instructionSet[parts[1]]
			if !ok {
				return nil, nil, fmt.Errorf("不明な命令: %s", opcodeStr)
			}
			if parts[1] == "DC" {
				return handleDC(parts)
			} else {
				if len(parts) > 2 {
					parts[1] = parts[2]
				}
			}
		}
		memoryAddress++
		opeCodeStr := fmt.Sprintf("%02x", instr.Opcode)
		memoryStr := fmt.Sprintf("%04x", memoryAddress)
		binary = append(binary, opeCodeStr)
		memory = append(memory, memoryStr)

		if instr.Operand != "None" {
			if len(parts) < 2 {
				return nil, nil, fmt.Errorf("オペランドが不足しています: %s", line)
			}
			if instr.Operand == "Memory" || instr.Operand == "Immediate" {
				memoryAddress++
				memoryStr := fmt.Sprintf("%04x", memoryAddress)
				result := strings.Replace(parts[1], "#", "", 1)
				binary = append(binary, result)
				memory = append(memory, memoryStr)
			} else if parts[1][0] == '#' {
				address := strings.Replace(parts[1], "#", "", 1)
				binary = append(binary, address[:2], address[2:])
				memoryAddress++
				memoryStr = fmt.Sprintf("%04x", memoryAddress)
				memory = append(memory, memoryStr)
				memoryAddress++
				memoryStr = fmt.Sprintf("%04x", memoryAddress)
				memory = append(memory, memoryStr)
			} else {
				address, ok := labelAddresses[parts[1]]
				if !ok {
					return nil, nil, fmt.Errorf("ラベルが見つかりません: %s", parts[1])
				}
				binary = append(binary, address[:2], address[2:])
				memoryAddress++
				memoryStr = fmt.Sprintf("%04x", memoryAddress)
				memory = append(memory, memoryStr)
				memoryAddress++
				memoryStr = fmt.Sprintf("%04x", memoryAddress)
				memory = append(memory, memoryStr)
			}
		}

		return memory, binary, nil
	}
}

func handleDC(parts []string) ([]string, []string, error) {
	address := strings.Replace(parts[0], "#", "", 1)
	value := strings.Replace(parts[2], "#", "", 1)
	return []string{address}, []string{value}, nil
}

func calculateLabelAddresses(filePath string) (map[string]string, error) {
	file, err := os.Open(filePath)
	if err != nil {
		return nil, fmt.Errorf("ファイルを開けませんでした: %v", err)
	}
	defer file.Close()

	address := 0
	labelAddresses := make(map[string]string)
	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		line := scanner.Text()
		line = strings.TrimSpace(line)
		parts := strings.Fields(line)

		if len(line) == 0 {
			continue
		}

		if strings.Contains(parts[0], ":") {
			label := parts[0][:len(parts[0])-1]
			if instr, ok := instructionSet[parts[1]]; ok {
				address += instr.Size
			}
			memoryStr := fmt.Sprintf("%04x", address)
			labelAddresses[label] = memoryStr
			continue
		}

		if instr, ok := instructionSet[parts[0]]; ok {
			address += instr.Size
			continue
		}
		if parts[0] == "PROGRAM" || parts[0] == "END" {
			continue
		}
		if instr, ok := instructionSet[parts[1]]; ok {
			address += instr.Size
		}
	}

	if err := scanner.Err(); err != nil {
		return nil, fmt.Errorf("ファイル読み込み中にエラーが発生しました: %v", err)
	}

	return labelAddresses, nil
}
