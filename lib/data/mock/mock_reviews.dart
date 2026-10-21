import '../models/review_model.dart';

final List<ReviewItem> mockReviews = [
  const ReviewItem(
    id: 'r1',
    customerName: 'Rajesh Sharma',
    rating: 5.0,
    comment: 'Hamare naye makan ki poori concealed wiring Zemtro Electrician se karwai. Bahut hi safai aur safety ke sath kaam kiya. Proper circuit segregation aur load distribution kiya. Highly recommended!',
    serviceType: 'Makan Wiring (Complete 3BHK)',
    location: 'Shanti Nagar, Sector 4',
    date: '2 days ago',
  ),
  const ReviewItem(
    id: 'r2',
    customerName: 'Vikram Patel',
    rating: 5.0,
    comment: 'Midnight ko 11 baje short circuit hua aur main MCB trip ho gayi. Call karne ke 25 minute me electrician pahunch gaya aur fault dhoondh kar fix kar diya. Very fast emergency response!',
    serviceType: 'Emergency Short Circuit',
    location: 'Green Park Colony',
    date: '1 week ago',
  ),
  const ReviewItem(
    id: 'r3',
    customerName: 'Dinesh Singhania (Factory Owner)',
    rating: 5.0,
    comment: 'Hamari industrial unit me 3-phase motor starter bar bar trip ho raha tha. Inhone Star-Delta panel ko inspect karke overload relay calibrate ki aur motor heating band ho gayi. Real technical expert.',
    serviceType: 'Industrial 3-Phase Panel',
    location: 'Phase-2 Industrial Area',
    date: '2 weeks ago',
  ),
  const ReviewItem(
    id: 'r4',
    customerName: 'Pooja Verma',
    rating: 4.9,
    comment: 'Dono split AC ki jet pump service karayi aur ek me gas recharge karwaya. Cooling ab zabardast ho rahi hai. Rate bhi market se kafi reasonable hai.',
    serviceType: 'AC Jet Wash & Gas Refill',
    location: 'Civil Lines',
    date: '3 weeks ago',
  ),
];
