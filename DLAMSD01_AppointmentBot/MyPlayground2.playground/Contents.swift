import NaturalLanguage
import CoreML

func answerKeyCustom(for string: String) -> String? {
    guard let embedding = NLEmbedding.sentenceEmbedding(for: .english) else { return nil }
    let exampleQueries = ["location_1" : "Where is your office located?",
                          "location_2" : "Where can I find you?",
                          "location_3" : "What is your adress?",
                          "opening_1" : "When are you open?",
                          "opening_2" : "What are your opening hours",
                          "opening_3" : "When is your office open?",
                          "appointment_1" : "When is my next appointment?",
                          "appointment_2" : "I would like to reschedule my appointment.",
                          "appointment_3" : "I have to cancel my appointment.",
    ]
    var answerKey: String? = nil
    var answerDistance = 2.0

    for (key, exampleQuery) in exampleQueries {
        var distance = embedding.distance(between: exampleQuery, and: string)
        if (distance < answerDistance){
            answerKey = key
            answerDistance = distance
        }
    }
        if answerDistance > 1.0 {
            answerKey = "misc"
        }
        return answerKey
}

print(answerKeyCustom(for: "Hi. How are you?"))
