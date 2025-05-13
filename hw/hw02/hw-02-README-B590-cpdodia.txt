B590/Spring 2025
HW2
03.30.25
Chirag Dodia  (cpdodia)

About the Hw2:

I completed the implementation of the EditCardsViewController, which now lets users modify the current question and answer via text fields. This controller is connected to the shared LearnerCardModel instance from the AppDelegate, ensuring that both the LearnerCards and EditCards tabs work with the same data. I also added two new methods to the model—setCurrentQuestion and setCurrentAnswer—along with getCurrentQuestion, which retrieves the current question without advancing the index. These enhancements enabled smooth editing and synchronization of the question/answer data between the two views.

An interesting aspect of this update is the shared model approach via AppDelegate, which ensures consistent state management across tabs. Additionally, I implemented error handling to manage cases where users try to edit empty or unselected values.

(Optional) I initially encountered issues with broken IBOutlet connections and nil crashes due to misconfigured storyboard wiring, but I resolved these by properly reconnecting the elements and verifying the custom class assignments.