import NaturalLanguage
import CreateML
import CoreML

if let embedding = NLEmbedding.sentenceEmbedding(for: .english){
    let exampleQueries = ["location_1" : embedding.vector(for: "Where is your office located?")!,
                          "location_2" : embedding.vector(for: "Where can I find you?")!,
                          "location_3" : embedding.vector(for: "What is your adress?")!,
                          "opening_1" : embedding.vector(for: "When are you open?")!,
                          "opening_2" : embedding.vector(for: "What are your opening hours")!,
                          "opening_3" : embedding.vector(for: "When is your office open?")!,
                          "appointment_1" : embedding.vector(for: "When is my next appointment?")!,
                          "appointment_2" : embedding.vector(for: "I would like to reschedule my appointment.")!,
                          "appointment_3" : embedding.vector(for: "I have to cancel my appointment.")!,
    ]
    
    let customEmbedding = try MLWordEmbedding(dictionary: exampleQueries)

    
    //try customEmbedding.write(to: URL(fileURLWithPath: "/Users/benjamin/Schreibtisch/ExampleQueryModel.mlmodel"))
    
}
let test = Bundle.main.url(forResource: "ExampleQueryModel", withExtension: "mlmodelc")
