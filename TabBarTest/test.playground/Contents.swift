import UIKit

let closure: (_ str: String)->Void = {str in
    print("wo i" + str)
}

func test(str1: String, closure: (_ str: String)->Void){
    print(str1)
    closure("swift")
}
test(str1: "我是第一行", closure: closure)
