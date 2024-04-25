import SwiftUI
import CoreData

struct ProfilePageView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Plant.entity(), sortDescriptors: []) var plants: FetchedResults<Plant>
    
    var body: some View {
        VStack {
            //Title for the page
            Text("Profile")
                .font(.title)
                .padding(.top)
                .padding(.top)
                .foregroundColor(Color.richGrey)
                .frame(maxWidth: .infinity)
            //we need some space here to break it up
            Spacer().frame(height: 40)
            
            //add new vstack to align elements to left of screen
            VStack(alignment: .leading) {
                //stats
                Text("Statistics")
                    .font(.headline)
                    .foregroundColor(Color.richGrey)
                
                //plants
                Text("Total Plants: \(plants.count)")
                //total watered
                Text("Total Times Watered: \(totalTimesWatered())")
                //total fed
                Text("Total Times Fed: \(totalTimesFed())")
            }
            //align to leading edge
            .frame(maxWidth: .infinity, alignment: .leading)
            
            //move the stats to the top
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.softLimeGreen.ignoresSafeArea())
    }

    //calculate total watered
    private func totalTimesWatered() -> Int {
        plants.reduce(0) {$0 + Int($1.timesWatered) }
    }

    //calculate total fed
    private func totalTimesFed() -> Int {
        plants.reduce(0) {$0 + Int($1.timesFed) }
    }

}



#Preview {
    ProfilePageView()
}
