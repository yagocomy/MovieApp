import UIKit
import MovieAppNetwork

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MovieNetwork.shared.request(
            "https://jsonplaceholder.typicode.com/todos/1",
            type: .get,
            response: SampleModel.self) { result in
                switch result {
                case .success(let data):
                    debugPrint(data)
                case .failure(let error):
                    debugPrint(error)
                }
            }
    }
}

