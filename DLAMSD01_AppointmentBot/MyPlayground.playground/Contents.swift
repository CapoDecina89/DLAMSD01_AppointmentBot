import UIKit
import NaturalLanguage
import CoreML

func answerKeyCustom(for string: String) -> [(String?, NLDistance?)] {
    guard let embedding = NLEmbedding.sentenceEmbedding(for: .english) else { return [(nil, nil)] }
    guard let queryVector = embedding.vector(for: string) else { return [(nil, nil)] }
    print(queryVector)
    
    let customEmbedding = try! NLEmbedding(contentsOf: Bundle.main.url(forResource: "ExampleQueryModel", withExtension: "mlmodelc")!)
    
    let nearestNeighbor: [(String, NLDistance)] =  embedding.neighbors(for: queryVector, maximumCount: 1)

    return nearestNeighbor
    }
print(answerKeyCustom(for: "I have to cancel my appointment."))

