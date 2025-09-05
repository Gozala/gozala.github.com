import Cocoa

let filePath = "/Users/gozala/Library/Mobile Documents/com~apple~CloudDocs/Papers/merkleCRDT.pdf"
var fileURL = URL(fileURLWithPath: filePath)

func getTags(url:URL) -> [String] {
    do {
        let resourceValues = try url.resourceValues(forKeys: [.tagNamesKey])
        let tags:[String] = resourceValues.tagNames ?? [String]()
        return tags
    } catch {
        return []
    }
}

func setTags(url:URL, tags:[String]) throws -> [String] {
    try (url as NSURL).setResourceValue(tags, forKey: .tagNamesKey)
    return tags
}

func addTags(url:URL, tags:[String]) throws -> [String] {
    var urlTags = getTags(url:url)
    urlTags.append(contentsOf: tags)
    return try setTags(url: <#T##URL#>, tags: urlTags)
}

do {
    getTags(url: fileURL)
    
    let webURL = URL(string:"https://github.com/automerge/automerge")!
    getTags(url: webURL)
    try setTags(url: webURL, tags: ["CRDT", "JSON-CRDT"])
    getTags(url:webURL)
} catch {
    print(error)
}
