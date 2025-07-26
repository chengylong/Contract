package contract

var enum_map = map[byte]int{'I': 1, 'V': 5, 'X': 10, 'L': 50, 'C': 100, 'D': 500, 'M': 1000}

// 罗马数字转整数
func RomanToInt(s string) int {
	total := 0
	len := len(s)
	for i := range s {
		if i < len-1 && enum_map[s[i]] < enum_map[s[i+1]] {
			total -= enum_map[s[i]]
		} else {
			total += enum_map[s[i]]
		}
	}
	return total
}

// 整数转罗马数
var enum_struct = []struct {
	value int
	enum  string
}{
	{1000, "M"},
	{900, "CM"},
	{500, "D"},
	{400, "CD"},
	{100, "C"},
	{90, "XC"},
	{50, "L"},
	{40, "XL"},
	{10, "X"},
	{9, "IX"},
	{5, "V"},
	{4, "IV"},
	{1, "I"},
}

func IntToRoman(num int) string {
	roman := []byte{}
	for _, v := range enum_struct {
		for num >= v.value {
			num -= v.value
			roman = append(roman, []byte(v.enum)...)
		}
		if num == 0 {
			break
		}
	}
	return string(roman)
}
