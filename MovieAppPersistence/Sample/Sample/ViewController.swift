import UIKit
import SwiftData
import MovieAppPersistence

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        MovieAppPersistence.shared.persistDataType(data: TodoModel.self)
        MovieAppPersistence.shared.saveData(data: TodoModel(id: "1", taskname: "Testando", time: 1.2))
        MovieAppPersistence.shared.getData(dataType: TodoModel.self) { result in
            switch result {
            case .success(let data):
                print(data[0].taskname)
                print(data[0].id)
            case .failure(let error):
                print(error)
            }
        }
    }
}

@Model
class TodoModel{
    @Attribute(.unique) var id: String
    var taskname: String
    var time: Double
    
    init(id: String, taskname: String,time: Double) {
        self.id = id
        self.taskname = taskname
        self.time = time
    }
    
}

