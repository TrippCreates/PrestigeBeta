import Foundation

struct University {
    let name: String
    let domains: [String]
    let rank: Int
}

class UniversityValidator {
    static let shared = UniversityValidator()
    
    // Top 25 US Universities and their email domains
    private let approvedUniversities: [University] = [
        University(name: "Massachusetts Institute of Technology", domains: ["mit.edu"], rank: 1),
        University(name: "Stanford University", domains: ["stanford.edu"], rank: 2),
        University(name: "Harvard University", domains: ["harvard.edu", "hbs.edu", "fas.harvard.edu"], rank: 3),
        University(name: "California Institute of Technology", domains: ["caltech.edu"], rank: 4),
        University(name: "Princeton University", domains: ["princeton.edu"], rank: 5),
        University(name: "Yale University", domains: ["yale.edu"], rank: 6),
        University(name: "Columbia University", domains: ["columbia.edu"], rank: 7),
        University(name: "University of Pennsylvania", domains: ["upenn.edu"], rank: 8),
        University(name: "Johns Hopkins University", domains: ["jhu.edu"], rank: 9),
        University(name: "Northwestern University", domains: ["u.northwestern.edu"], rank: 10),
        University(name: "Duke University", domains: ["duke.edu"], rank: 11),
        University(name: "Dartmouth College", domains: ["dartmouth.edu"], rank: 12),
        University(name: "Brown University", domains: ["brown.edu"], rank: 13),
        University(name: "University of Chicago", domains: ["uchicago.edu"], rank: 14),
        University(name: "Cornell University", domains: ["cornell.edu"], rank: 15),
        University(name: "Rice University", domains: ["rice.edu"], rank: 16),
        University(name: "University of California, Berkeley", domains: ["berkeley.edu"], rank: 17),
        University(name: "University of California, Los Angeles", domains: ["ucla.edu"], rank: 18),
        University(name: "University of Notre Dame", domains: ["nd.edu"], rank: 19),
        University(name: "Vanderbilt University", domains: ["vanderbilt.edu"], rank: 20),
        University(name: "Carnegie Mellon University", domains: ["cmu.edu"], rank: 21),
        University(name: "University of Michigan", domains: ["umich.edu"], rank: 22),
        University(name: "Georgetown University", domains: ["georgetown.edu"], rank: 23),
        University(name: "University of Virginia", domains: ["virginia.edu"], rank: 24),
        University(name: "Washington University in St. Louis", domains: ["wustl.edu"], rank: 25),
        University(name: "New York University", domains: ["stern.nyu.edu", "nyu.edu"], rank: 30),
        University(name: "Georgia Institute of Technology", domains: ["gatech.edu"], rank: 33)
    ]
    
    func isValidUniversityEmail(_ email: String) -> (isValid: Bool, universityName: String?) {
        let emailDomain = email.split(separator: "@").last?.lowercased() ?? ""
        
        for university in approvedUniversities {
            if university.domains.contains(where: { emailDomain.contains($0.lowercased()) }) {
                return (true, university.name)
            }
        }
        return (false, nil)
    }
    
    func getUniversityInfo(for email: String) -> University? {
        let emailDomain = email.split(separator: "@").last?.lowercased() ?? ""
        return approvedUniversities.first { university in
            university.domains.contains(where: { emailDomain.contains($0.lowercased()) })
        }
    }
    
    // Get all approved universities
    func getAllUniversities() -> [University] {
        return approvedUniversities
    }
} 
