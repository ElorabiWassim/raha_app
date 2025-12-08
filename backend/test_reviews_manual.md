# Testing SP Review Functionality

## Prerequisites
- Backend server running on port 5000
- Supabase database with reviews table
- Test service provider ID (UUID)

## Method 1: Test with PowerShell/cURL

### 1. Test Get Reviews for SP
```powershell
# Get reviews for a specific service provider
$spId = "5e7910fe-9b5e-4d0a-adeb-327e8781c0e7"
Invoke-RestMethod -Uri "http://localhost:5000/api/sp/reviews/$spId" -Method Get
```

Expected Response:
```json
{
  "success": true,
  "data": [
    {
      "review_id": "...",
      "homeowner_name": "...",
      "rating": 4.5,
      "review_text": "...",
      "created_at": "..."
    }
  ],
  "count": 1
}
```

### 2. Test Get Average Rating
```powershell
# Get average rating for a service provider
$spId = "5e7910fe-9b5e-4d0a-adeb-327e8781c0e7"
Invoke-RestMethod -Uri "http://localhost:5000/api/sp/rating/$spId" -Method Get
```

Expected Response:
```json
{
  "success": true,
  "data": {
    "average_rating": 4.5,
    "total_reviews": 10
  }
}
```

## Method 2: Test with Postman

1. **Import Collection**
   - Create new request
   - Method: GET
   - URL: `http://localhost:5000/api/sp/reviews/{spId}`
   - Replace `{spId}` with actual UUID

2. **Test Scenarios**
   - Get reviews: `GET /api/sp/reviews/:spId`
   - Get rating: `GET /api/sp/rating/:spId`

## Method 3: Test in Flutter App

### Create a Test Widget

Create file: `flutter_app/lib/modules/test/test_reviews_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../cubits/reviews_cubit.dart';
import '../../cubits/reviews_state.dart';

class TestReviewsScreen extends StatelessWidget {
  final String spId;
  
  const TestReviewsScreen({
    Key? key, 
    required this.spId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Reviews'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<ReviewsCubit>().loadReviewsForSP(spId);
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (_) => GetIt.instance<ReviewsCubit>()..loadReviewsForSP(spId),
        child: BlocConsumer<ReviewsCubit, ReviewsState>(
          listener: (context, state) {
            if (state is ReviewsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ReviewsLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is ReviewsLoaded) {
              return Column(
                children: [
                  // Average Rating Card
                  if (state.averageRating != null)
                    Card(
                      margin: EdgeInsets.all(16),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'Average Rating',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 32),
                                SizedBox(width: 8),
                                Text(
                                  state.averageRating!.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${state.reviews.length} reviews',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Reviews List
                  Expanded(
                    child: state.reviews.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.rate_review_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No reviews yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: state.reviews.length,
                            itemBuilder: (context, index) {
                              final review = state.reviews[index];
                              return Card(
                                margin: EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: Text(
                                      review.homeownerName[0].toUpperCase(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      Text(review.homeownerName),
                                      SizedBox(width: 8),
                                      Row(
                                        children: List.generate(
                                          5,
                                          (i) => Icon(
                                            i < review.rating
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.amber,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (review.reviewText != null) ...[
                                        SizedBox(height: 8),
                                        Text(review.reviewText!),
                                      ],
                                      SizedBox(height: 4),
                                      Text(
                                        'Posted ${_formatDate(review.createdAt)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  isThreeLine: review.reviewText != null,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            }

            return Center(
              child: Text('Tap refresh to load reviews'),
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes} minutes ago';
      }
      return '${diff.inHours} hours ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
```

### Navigate to Test Screen

Add this navigation anywhere in your app:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => TestReviewsScreen(
      spId: '5e7910fe-9b5e-4d0a-adeb-327e8781c0e7',
    ),
  ),
);
```

## Method 4: Insert Test Data in Database

### Using Supabase Dashboard

1. Go to your Supabase dashboard
2. Navigate to Table Editor
3. Select `reviews` table
4. Insert test data:

```sql
INSERT INTO reviews (
  booking_id,
  homeowner_id,
  sp_id,
  rating,
  review_text,
  status
) VALUES (
  'test-booking-uuid',
  'test-homeowner-uuid',
  '5e7910fe-9b5e-4d0a-adeb-327e8781c0e7',
  4.5,
  'Excellent service! Very professional and punctual.',
  'visible'
);
```

### Create multiple test reviews:
```sql
-- Review 1
INSERT INTO reviews (booking_id, homeowner_id, sp_id, rating, review_text, status)
VALUES (gen_random_uuid(), gen_random_uuid(), '5e7910fe-9b5e-4d0a-adeb-327e8781c0e7', 5, 'Outstanding work!', 'visible');

-- Review 2
INSERT INTO reviews (booking_id, homeowner_id, sp_id, rating, review_text, status)
VALUES (gen_random_uuid(), gen_random_uuid(), '5e7910fe-9b5e-4d0a-adeb-327e8781c0e7', 4, 'Good service', 'visible');

-- Review 3
INSERT INTO reviews (booking_id, homeowner_id, sp_id, rating, review_text, status)
VALUES (gen_random_uuid(), gen_random_uuid(), '5e7910fe-9b5e-4d0a-adeb-327e8781c0e7', 3.5, 'Decent job', 'visible');
```

## Method 5: Test Submission Flow (Homeowner)

### Test Review Submission Endpoint

```powershell
# Submit a new review
$body = @{
    booking_id = "test-booking-uuid"
    sp_id = "5e7910fe-9b5e-4d0a-adeb-327e8781c0e7"
    rating = 4.5
    review_text = "Great service!"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/api/reviews" -Method Post -Body $body -ContentType "application/json"
```

## Quick Test Commands

```powershell
# Set test SP ID
$spId = "5e7910fe-9b5e-4d0a-adeb-327e8781c0e7"

# Test 1: Get reviews
Write-Host "Testing GET reviews..." -ForegroundColor Cyan
Invoke-RestMethod -Uri "http://localhost:5000/api/sp/reviews/$spId"

# Test 2: Get rating
Write-Host "`nTesting GET rating..." -ForegroundColor Cyan
Invoke-RestMethod -Uri "http://localhost:5000/api/sp/rating/$spId"
```

## Expected Behavior

### ✅ Success Indicators:
- Backend returns HTTP 200 status
- Response has `"success": true`
- Reviews array contains review objects
- Average rating is calculated correctly
- Flutter app displays reviews without errors

### ❌ Common Issues:
- **Connection refused**: Backend not running on port 5000
- **Empty data array**: No reviews in database for that SP
- **Database error**: Supabase credentials incorrect
- **CORS error**: CORS not properly configured

## Troubleshooting

### Backend not responding:
```powershell
# Check if backend is running
cd backend
npm run dev
```

### Database connection issues:
```powershell
# Check .env file has correct Supabase credentials
cd backend
cat .env
```

### Flutter app not connecting:
- Check `main.dart` has correct base URL: `http://localhost:5000`
- For web: Use `http://localhost:5000`
- For Android emulator: Use `http://10.0.2.2:5000`

## Integration Test Checklist

- [ ] Backend server running on port 5000
- [ ] SP routes mounted at `/api/sp`
- [ ] `GET /api/sp/reviews/:spId` returns reviews
- [ ] `GET /api/sp/rating/:spId` returns average rating
- [ ] Flutter ReviewsCubit loads reviews
- [ ] Flutter UI displays reviews correctly
- [ ] Error states handled properly
- [ ] Empty state displayed when no reviews
