#!/usr/bin/env python3
"""
Backend API Testing for Club Vacacional Rating System
Testing the rating submission error with new data structure
"""

import requests
import json
import sys
from datetime import datetime

# Use localhost since we're testing internally
BASE_URL = "http://localhost:3000/api"

def test_rating_submission_error():
    """Test the specific rating submission error reported by user"""
    print("=== Testing Rating Submission Error ===")
    
    # Test data structure from the review request
    new_rating_data = {
        "evaluator_id": "avail_40196",
        "evaluated_id": "avail_68891", 
        "other_employee_name": None,
        "ratings_json": {
            "stars": {"explanation_Xhare Rewards": 4},
            "yesNo": {"¿Saludó a los prospectos?": True},
            "numbers": {"¿Cuántos drops hubo?": 2}
        },
        "comments": "Test comment",
        "date": "2025-01-29"
    }
    
    print(f"Testing POST {BASE_URL}/ratings with new data structure...")
    print(f"Data being sent: {json.dumps(new_rating_data, indent=2)}")
    
    try:
        response = requests.post(f"{BASE_URL}/ratings", json=new_rating_data, timeout=10)
        print(f"Response Status: {response.status_code}")
        print(f"Response Headers: {dict(response.headers)}")
        
        if response.status_code == 200:
            result = response.json()
            print("✅ SUCCESS: Rating submitted successfully")
            print(f"Response: {json.dumps(result, indent=2)}")
            return True
        else:
            print("❌ FAILED: Rating submission failed")
            try:
                error_data = response.json()
                print(f"Error Response: {json.dumps(error_data, indent=2)}")
            except:
                print(f"Raw Error Response: {response.text}")
            return False
            
    except requests.exceptions.RequestException as e:
        print(f"❌ REQUEST ERROR: {str(e)}")
        return False

def test_rating_with_other_employee():
    """Test rating submission with 'other' employee"""
    print("\n=== Testing Rating with 'Other' Employee ===")
    
    other_rating_data = {
        "evaluator_id": "avail_40196",
        "evaluated_id": "other", 
        "other_employee_name": "External Employee Name",
        "ratings_json": {
            "stars": {"explanation_Xhare Rewards": 3},
            "yesNo": {"¿Saludó a los prospectos?": False},
            "numbers": {"¿Cuántos drops hubo?": 5}
        },
        "comments": "Rating for external employee",
        "date": "2025-01-29"
    }
    
    print(f"Testing POST {BASE_URL}/ratings with 'other' employee...")
    print(f"Data being sent: {json.dumps(other_rating_data, indent=2)}")
    
    try:
        response = requests.post(f"{BASE_URL}/ratings", json=other_rating_data, timeout=10)
        print(f"Response Status: {response.status_code}")
        
        if response.status_code == 200:
            result = response.json()
            print("✅ SUCCESS: Rating with 'other' employee submitted successfully")
            print(f"Response: {json.dumps(result, indent=2)}")
            return True
        else:
            print("❌ FAILED: Rating with 'other' employee failed")
            try:
                error_data = response.json()
                print(f"Error Response: {json.dumps(error_data, indent=2)}")
            except:
                print(f"Raw Error Response: {response.text}")
            return False
            
    except requests.exceptions.RequestException as e:
        print(f"❌ REQUEST ERROR: {str(e)}")
        return False

def test_database_schema_compatibility():
    """Test if the database schema can handle the new rating structure"""
    print("\n=== Testing Database Schema Compatibility ===")
    
    # First, let's check existing ratings to see current structure
    try:
        response = requests.get(f"{BASE_URL}/ratings", timeout=10)
        print(f"GET /ratings Status: {response.status_code}")
        
        if response.status_code == 200:
            ratings = response.json()
            print(f"✅ Successfully retrieved {len(ratings)} existing ratings")
            
            if ratings:
                print("Sample existing rating structure:")
                print(json.dumps(ratings[0], indent=2))
            else:
                print("No existing ratings found")
            return True
        else:
            print("❌ FAILED: Could not retrieve existing ratings")
            try:
                error_data = response.json()
                print(f"Error Response: {json.dumps(error_data, indent=2)}")
            except:
                print(f"Raw Error Response: {response.text}")
            return False
            
    except requests.exceptions.RequestException as e:
        print(f"❌ REQUEST ERROR: {str(e)}")
        return False

def test_api_endpoint_availability():
    """Test if the ratings API endpoint is available"""
    print("\n=== Testing API Endpoint Availability ===")
    
    try:
        # Test root API endpoint
        response = requests.get(BASE_URL, timeout=10)
        print(f"GET {BASE_URL} Status: {response.status_code}")
        
        if response.status_code == 200:
            result = response.json()
            print("✅ API root endpoint working")
            print(f"Available endpoints: {result.get('endpoints', [])}")
            
            # Check if ratings endpoint is listed
            if '/api/ratings' in result.get('endpoints', []):
                print("✅ Ratings endpoint is listed in available endpoints")
                return True
            else:
                print("❌ Ratings endpoint not listed in available endpoints")
                return False
        else:
            print("❌ FAILED: API root endpoint not working")
            return False
            
    except requests.exceptions.RequestException as e:
        print(f"❌ REQUEST ERROR: {str(e)}")
        return False

def test_simple_rating_structure():
    """Test with a simpler rating structure to isolate the issue"""
    print("\n=== Testing Simple Rating Structure ===")
    
    simple_rating_data = {
        "evaluator_id": "test_evaluator",
        "evaluated_id": "test_evaluated", 
        "ratings_json": {
            "overall": 5
        },
        "comments": "Simple test",
        "date": "2025-01-29"
    }
    
    print(f"Testing POST {BASE_URL}/ratings with simple structure...")
    print(f"Data being sent: {json.dumps(simple_rating_data, indent=2)}")
    
    try:
        response = requests.post(f"{BASE_URL}/ratings", json=simple_rating_data, timeout=10)
        print(f"Response Status: {response.status_code}")
        
        if response.status_code == 200:
            result = response.json()
            print("✅ SUCCESS: Simple rating submitted successfully")
            print(f"Response: {json.dumps(result, indent=2)}")
            return True
        else:
            print("❌ FAILED: Simple rating submission failed")
            try:
                error_data = response.json()
                print(f"Error Response: {json.dumps(error_data, indent=2)}")
            except:
                print(f"Raw Error Response: {response.text}")
            return False
            
    except requests.exceptions.RequestException as e:
        print(f"❌ REQUEST ERROR: {str(e)}")
        return False

def main():
    """Run all rating submission tests"""
    print("Starting Club Vacacional Rating System Backend Tests")
    print("=" * 60)
    
    test_results = []
    
    # Test 1: API endpoint availability
    test_results.append(("API Endpoint Availability", test_api_endpoint_availability()))
    
    # Test 2: Database schema compatibility
    test_results.append(("Database Schema Compatibility", test_database_schema_compatibility()))
    
    # Test 3: Simple rating structure (baseline test)
    test_results.append(("Simple Rating Structure", test_simple_rating_structure()))
    
    # Test 4: Rating submission with new structure
    test_results.append(("Rating Submission (New Structure)", test_rating_submission_error()))
    
    # Test 5: Rating with 'other' employee
    test_results.append(("Rating with 'Other' Employee", test_rating_with_other_employee()))
    
    # Summary
    print("\n" + "=" * 60)
    print("TEST SUMMARY")
    print("=" * 60)
    
    passed = 0
    failed = 0
    
    for test_name, result in test_results:
        status = "✅ PASSED" if result else "❌ FAILED"
        print(f"{test_name}: {status}")
        if result:
            passed += 1
        else:
            failed += 1
    
    print(f"\nTotal Tests: {len(test_results)}")
    print(f"Passed: {passed}")
    print(f"Failed: {failed}")
    
    if failed > 0:
        print("\n❌ CRITICAL ISSUES FOUND - Rating submission is not working properly")
        sys.exit(1)
    else:
        print("\n✅ ALL TESTS PASSED - Rating system working correctly")
        sys.exit(0)

if __name__ == "__main__":
    main()