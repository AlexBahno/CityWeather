# City Weather 
This app was made as a technical task.<br>
Stack: SwiftUI, Combine, Alamofire<br>
Architecture: MVVM+Coordinator<br>
Coordinator was written in SwiftUI, as it was one of the conditions for task, with using NavigationPath and NavigationStack. For each flow, there is a ContenView, which stores NavigationStack. Also, for creating view, ViewFactory was used.<br>
For Network layer Alamofire was used with the combination of Async/Await. Alamofire let`t us to make requests to network and receive responses, while Async/Await API let's us handle correct receiving of data.

