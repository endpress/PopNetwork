# PopNetwork
## 用面向协议方式写的一个网络类

---

## Usage

### Decode a Object from server

#### Create your Object. Make it confirm Decodable protocol

```swift
struct User: Decodable {
    let name: String
    let message: String
    
    typealias RequestTpye = Request
    
    static var request: RequestTpye {
        return Request(url: "https://api.onevcat.com/users/onevcat")
    }
    
    static func parser(from data: Data) -> User? {
        if let dic = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
            guard let dic = dic as? Dictionary<String, String> else { return nil }
            guard let name = dic["name"], let message = dic["message"] else { return nil }
            let user = User(name: name, message: message)
            return user
        }
        return nil
    }
}
```
#### Use your Object 

```swift
User.decode { (result) in
            switch result {
            case .Success(let user):
                print("\(user)")
            case .Faliure(let error):
                if case .error(let reason) = error {
                    print("\(reason)")
                }
            }
        }
```
