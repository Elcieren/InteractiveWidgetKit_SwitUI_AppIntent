## InteractiveWidgetKit_SwitUI_AppIntent
| SwiftData Veri Ekle&&Silme&&Düzenleme |
|---------|
| ![Video 1](https://github.com/user-attachments/assets/22a8dc8d-e506-4db0-96c6-ad950186bbb2) | 


 <details>
    <summary><h2>Uygulamanın Amacı ve Senaryo Mantığı</h2></summary>
    Proje Amacı
   Bu SwiftUI uygulaması, kullanıcıların etkileşimli widget'lar ile "To-Do Listesi" (Yapılacaklar Listesi) öğelerini takip etmelerini ve tamamlanmış öğeleri işaretlemelerini sağlar. Widget, kullanıcıların günlük görevlerini hızlı bir şekilde gözden geçirmesine ve tamamladıklarında bunları işaretlemelerine olanak tanır. Bu uygulama, aynı zamanda iOS 17'deki WidgetKit özelliklerini kullanarak widget'lar arasında veri paylaşımını ve etkileşimi gösterir
  </details>  

  <details>
    <summary><h2>ToDo Veri Modeli</h2></summary>
    Bu yapı, her bir ToDo öğesini temsil eder. Identifiable protokolünü benimseyerek, her öğe benzersiz bir kimlik (id) alır. name özelliği görev adı, isDone ise görevin tamamlanıp tamamlanmadığını belirten bir boolean değeri tutar
    
    ```
     struct ToDo: Identifiable {
    let id: String = UUID().uuidString
    var name: String
    var isDone: Bool = false
    }



    ```
  </details> 


  <details>
    <summary><h2>Paylaşılan Veri</h2></summary>
    SharedDatas sınıfı, uygulama genelinde veri paylaşımını sağlayan bir singleton (tekil) sınıfıdır. Burada, toDos dizisi sabit verilerle (önceden belirlenmiş görevlerle) başlatılmıştır. Bu veri, widget tarafından görüntülenir ve güncellenir
    
    ```
    class SharedDatas {
    static let shared = SharedDatas()
    
    var toDos: [ToDo] = [
        .init(name: "Spor Gidiceksin"),
        .init(name: "Toplantiya Katil"),
        .init(name: "Kopegi Yuruyuse Cikar")
    ]
    }
    ```
  </details> 


  <details>
    <summary><h2>Widget Provider</h2></summary>
   Provider, WidgetKit tarafından kullanılan bir TimelineProvider protokolünü uygular. Bu protokol, widget'ın görüntüleneceği zamanı ve veriyi belirler:
   placeholder: Widget ilk başlatıldığında görüntülenecek geçici veriyi döner.
   getSnapshot: Widget'ın anlık görüntüsünü döner (gösterim için).
   getTimeline: Widget'ın zaman çizelgesini oluşturur ve ne zaman güncelleneceğini belirler. Burada, ilk üç öğe gösterilmektedir
    
    ```
    struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ToDoEntry {
        ToDoEntry(toDoToDisplay: Array(SharedDatas.shared.toDos.prefix(3)))
    }

    func getSnapshot(in context: Context, completion: @escaping (ToDoEntry) -> ()) {
        let entry = ToDoEntry(toDoToDisplay: Array(SharedDatas.shared.toDos.prefix(3)))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let toDisplay = Array(SharedDatas.shared.toDos.prefix(3))
        let timeline = Timeline(entries: [ToDoEntry(toDoToDisplay: toDisplay)], policy: .atEnd)
        completion(timeline)
    }
    }




    ```
  </details> 

  

  
  <details>
    <summary><h2>Widget Girişi (Entry):</h2></summary>
     ToDoEntry, TimelineEntry protokolüne uyar ve widget'ın görüntüleyeceği veriyi içerir. Bu yapıda, gösterilecek olan görevler (toDoToDisplay) listesi tutulur
    
    ```
     struct ToDoEntry: TimelineEntry {
    let date: Date = .now
    var toDoToDisplay: [ToDo]
    }


    ```
  </details> 

  <details>
    <summary><h2>Widget Görünümü</h2></summary>
      ToDoWidgetEntryView, widget'ı ekranda görsel olarak sunar. Burada:
      Text ile başlık eklenir.
      ForEach kullanılarak, her bir ToDo öğesi bir Button ile birlikte gösterilir.
      Button'ın tıklanması, ComplateToDoIntent intentini tetikler ve ilgili öğe tamamlanmış olarak işaretlenir.
      Eğer tüm görevler tamamlanmışsa, "ToDos Completed" yazısı gösterilir.
    
    ```
     struct ToDoWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("ToDo Items")
                .fontWeight(.bold)
                .padding(.bottom, 5)
            VStack {
                if entry.toDoToDisplay.isEmpty {
                    Text("ToDos Completed")
                } else {
                    ForEach(entry.toDoToDisplay) { toDo in
                        HStack {
                            Button(intent: ComplateToDoIntent(id: toDo.id)) {
                                Image(systemName: toDo.isDone ? "checkmark.circle.fill" : "circle").foregroundStyle(.blue)
                            }.buttonStyle(.plain)

                            VStack(alignment: .leading) {
                                Text(toDo.name).lineLimit(1).textScale(.secondary).strikethrough(toDo.isDone)
                                Divider()
                            }
                        }
                    }
                }
            }
        }
    }
    }




    ```
  </details> 




  <details>
    <summary><h2>ComplateToDoIntent Intenti</h2></summary>
      ComplateToDoIntent, kullanıcıların bir görevi tamamlaması için bir intent tanımlar. Bu intent, aşağıdaki adımları izler:
      id parametresi ile, hangi görevin tamamlanacağı belirlenir.
      perform() fonksiyonu, bu id ile toDos listesinde bir öğe arar.
      Öğenin isDone durumu, toggle() fonksiyonu ile tersine çevrilir (tamamlanmış/olmayan duruma gelir)
    
    ```
     struct ComplateToDoIntent: AppIntent {
    static var title: LocalizedStringResource = "Complete To Do"
    
    @Parameter(title:"ToDo ID")
    var id: String
    
    init() {}

    init(id: String) {
        self.id = id
    }

    func perform() async throws -> some IntentResult {
        if let index = SharedDatas.shared.toDos.firstIndex(where: {
            $0.id == id
        }) {
            SharedDatas.shared.toDos[index].isDone.toggle()
            print("Database update")
        }
        return .result()
    }
    }





    ```
  </details> 



  


<details>
    <summary><h2>Uygulama Görselleri </h2></summary>
    
    
 <table style="width: 100%;">
    <tr>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Etkilesimli Widget Buyuk Gorunum</h4>
            <img src="https://github.com/user-attachments/assets/a7c155f0-0fc0-4676-bd8c-f5ff360d4faf" style="width: 100%; height: auto;">
        </td>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Etkilesimli Widget Kucuk Gorunum</h4>
            <img src="https://github.com/user-attachments/assets/ab622ee5-ef5a-4554-8504-ae96f7cf82e6" style="width: 100%; height: auto;">
        </td>
    </tr>
</table>
  </details> 
