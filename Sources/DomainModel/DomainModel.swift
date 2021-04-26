struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    let amount: Int
    let currency: String
    
    init(amount amt: Int, currency curr: String) {
        self.amount = amt
        self.currency = curr
    }
    
    func convert(_ x: String) -> Money {
        var dollar = Double(amount)
        
        if (currency != "USD") {
            if (currency == "GBP") {
                dollar = dollar * 2
            } else if (currency == "EUR") {
                dollar = dollar / 1.5
            } else if (currency == "CAN") {
                dollar = dollar / 1.25
            }
        }
        
        if (x == "USD") {
            return Money(amount: Int(dollar), currency: x)
        } else if (x == "GBP") {
            return (Money(amount: Int(dollar * 0.5), currency: x))
        } else if (x == "EUR") {
            return (Money(amount: Int(dollar * 1.5), currency: x))
        } else {
            return (Money(amount: Int(dollar * 1.25), currency: x))
        }
         
        
    }
    
    func add(_ mon: Money) -> Money {
        if (mon.currency == currency) {
            return (Money(amount: (mon.amount + amount), currency: mon.currency))
        } else {
            let conversion = self.convert(mon.currency)
            return (Money(amount: (mon.amount + conversion.amount), currency: mon.currency))
        }
    }
    
    func subtract(_ mon:Money) -> Money {
        if (mon.currency == currency) {
            return (Money(amount: (mon.amount - amount), currency: mon.currency))
        } else {
            let conversion = self.convert(mon.currency)
            return (Money(amount: (mon.amount - conversion.amount), currency: mon.currency))
        }
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    let title: String
    var type: JobType
    
    init (title ti:String, type ty: JobType) {
        self.title = ti
        self.type = ty
    }
    
    
    func calculateIncome (_ hours: Int) ->  Int{
        switch type {
        case .Hourly (let wage):
            return Int(wage * Double(hours))
        case .Salary (let amount):
            return Int(amount)
        }
    }
    
    func raise (byAmount amount: Int){
        switch type {
        case .Hourly(let wage):
            let newWage = wage + Double(amount)
            type = JobType.Hourly(newWage)
        case .Salary(let salary):
            let newSalary = Double(salary) + Double(amount)
            type = JobType.Salary(UInt(newSalary))
        }
    }
    
    func raise (byAmount amount: Double){
        switch type {
        case .Hourly(let wage):
            let newWage = wage + Double(amount)
            type = JobType.Hourly(newWage)
        case .Salary(let salary):
            let newSalary = Double(salary) + Double(amount)
            type = JobType.Salary(UInt(newSalary))
        }
    }
    
    func raise (byPercent percent:Int){
        switch type {
        case .Hourly(let wage):
            let newWage = wage * (Double(percent) + 1.0)
            type = JobType.Hourly(newWage)
        case .Salary(let salary):
            let newSalary = Double(salary) * (Double(percent) + 1.0)
            type = JobType.Salary(UInt(newSalary))
        }
    }
    
    func raise (byPercent percent:Double){
        switch type {
        case .Hourly(let wage):
            let newWage = wage * (Double(percent) + 1.0)
            type = JobType.Hourly(newWage)
        case .Salary(let salary):
            let newSalary = Double(salary) * (Double(percent) + 1.0)
            type = JobType.Salary(UInt(newSalary))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    let firstName: String
    let lastName: String
    let age: Int
    var spouse: Person? = nil {
        didSet {
            if (age <= 16) {
                spouse = nil
            }
        }
    }
    var job: Job? = nil {
        didSet {
            if (age <= 16) {
                job = nil
            }
        }
    }
    
    init (firstName fn: String, lastName ln: String, age a: Int) {
        self.firstName = fn
        self.lastName = ln
        self.age = a
    }
    
    func toString() -> String{
        return ("[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(String(describing: job)) spouse:\(String(describing: spouse))]")
    }
}


////////////////////////////////////
// Family
//
public class Family {
    var members: [Person]
    
    init (spouse1 sp1: Person, spouse2 sp2: Person) {
        self.members = []
        if (sp1.spouse == nil && sp2.spouse == nil) {
            sp1.spouse = sp2
            sp2.spouse = sp1
        } else {
            return
        }
        
        self.members = [sp1, sp2]
    }
    
    func haveChild(_ child: Person) -> Bool{
        if (members[0].age < 21 && members[1].age < 21) {
            return false
        } else {
            members.append(child)
            return true
        }
    }
    
    func householdIncome() -> Int{
        var sum = 0.0
        
        for member in members {
            if (member.job != nil) {
                sum += Double(member.job?.calculateIncome(2000) ?? 0)
            }
        }
        return Int(sum)
    }
    
}

