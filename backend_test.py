#!/usr/bin/env python3
"""
Club Vacacional Backend Testing Script
Tests login, registration, and database issues as reported in the review request.
"""

import requests
import json
import sys
import os
from datetime import datetime

# Get base URL from environment - using external URL for testing
BASE_URL = "https://hadfdgbyxhbqgjycbftv.supabase.co/api"

# Test configuration
TEST_EMAIL = "prueba@test.com"
TEST_PASSWORD = "test123"
EXPECTED_EMPLOYEE_NAME = "ALEJANDRO ORTIZ BENITEZ"
EXPECTED_EMPLOYEE_COUNT = 231

def print_test_result(test_name, success, message="", data=None):
    """Print formatted test results"""
    status = "✅ PASS" if success else "❌ FAIL"
    print(f"{status} {test_name}")
    if message:
        print(f"   {message}")
    if data and isinstance(data, dict):
        print(f"   Data: {json.dumps(data, indent=2)[:200]}...")
    elif data:
        print(f"   Data: {str(data)[:200]}...")
    print()

def test_api_root():
    """Test the root API endpoint"""
    try:
        response = requests.get(f"{BASE_URL}")
        if response.status_code == 200:
            data = response.json()
            expected_endpoints = ['/api/users', '/api/ratings', '/api/follow-ups']
            has_endpoints = all(endpoint in str(data) for endpoint in expected_endpoints)
            print_test_result(
                "API Root Endpoint", 
                has_endpoints,
                f"Status: {response.status_code}, Has expected endpoints: {has_endpoints}",
                data
            )
            return has_endpoints
        else:
            print_test_result(
                "API Root Endpoint", 
                False,
                f"Status: {response.status_code}, Response: {response.text[:200]}"
            )
            return False
    except Exception as e:
        print_test_result("API Root Endpoint", False, f"Exception: {str(e)}")
        return False
    
def test_get_users():
    """Test GET /api/users endpoint"""
    try:
        response = requests.get(f"{BASE_URL}/users")
        if response.status_code == 200:
            users = response.json()
            print_test_result(
                "GET /api/users", 
                True,
                f"Status: {response.status_code}, Users count: {len(users)}",
                {"sample_users": users[:2] if users else []}
            )
            return users
        else:
            print_test_result(
                "GET /api/users", 
                False,
                f"Status: {response.status_code}, Response: {response.text[:200]}"
            )
            return []
    except Exception as e:
        print_test_result("GET /api/users", False, f"Exception: {str(e)}")
        return []
    
def test_get_available_employees():
    """Test GET /api/available-employees endpoint"""
    try:
        response = requests.get(f"{BASE_URL}/available-employees")
        if response.status_code == 200:
            employees = response.json()
            count = len(employees)
            expected_count_met = count == EXPECTED_EMPLOYEE_COUNT
            
            # Look for ALEJANDRO ORTIZ BENITEZ
            alejandro_found = False
            alejandro_data = None
            for emp in employees:
                full_name = f"{emp.get('first_name', '')} {emp.get('last_name', '')}".strip().upper()
                if EXPECTED_EMPLOYEE_NAME.upper() in full_name:
                    alejandro_found = True
                    alejandro_data = emp
                    break
            
            print_test_result(
                "GET /api/available-employees", 
                True,
                f"Status: {response.status_code}, Employees count: {count} (expected: {EXPECTED_EMPLOYEE_COUNT}), Alejandro found: {alejandro_found}",
                {"count": count, "alejandro": alejandro_data, "sample": employees[:2] if employees else []}
            )
            return employees, alejandro_found, alejandro_data
        else:
            print_test_result(
                "GET /api/available-employees", 
                False,
                f"Status: {response.status_code}, Response: {response.text[:200]}"
            )
            return [], False, None
    except Exception as e:
        print_test_result("GET /api/available-employees", False, f"Exception: {str(e)}")
        return [], False, None

def test_user_exists(users, email):
    """Check if a specific user exists in the users list"""
    user_found = False
    user_data = None
    
    for user in users:
        if user.get('email', '').lower() == email.lower():
            user_found = True
            user_data = user
            break
    
    print_test_result(
        f"User {email} exists", 
        user_found,
        f"User found: {user_found}",
        user_data
    )
    return user_found, user_data

def test_user_employee_relationship(user_data):
    """Test if user is properly linked to employee data"""
    if not user_data:
        print_test_result("User-Employee Relationship", False, "No user data provided")
        return False
    
    has_employee_data = 'available_employees' in user_data and user_data['available_employees'] is not None
    employee_name = ""
    
    if has_employee_data:
        emp = user_data['available_employees']
        employee_name = f"{emp.get('first_name', '')} {emp.get('last_name', '')}".strip()
        is_alejandro = EXPECTED_EMPLOYEE_NAME.upper() in employee_name.upper()
    else:
        is_alejandro = False
    
    print_test_result(
        "User-Employee Relationship", 
        has_employee_data and is_alejandro,
        f"Has employee data: {has_employee_data}, Employee: {employee_name}, Is Alejandro: {is_alejandro}",
        user_data.get('available_employees') if has_employee_data else None
    )
    return has_employee_data and is_alejandro

def test_registration_flow(employees, alejandro_data):
    """Test user registration flow"""
    if not alejandro_data:
        print_test_result("Registration Flow", False, "Alejandro employee data not found for registration test")
        return False
    
    # Test registration payload
    registration_data = {
        "email": "test_registration@test.com",
        "employee_id": alejandro_data.get('id')
    }
    
    try:
        response = requests.post(
            f"{BASE_URL}/users",
            headers={'Content-Type': 'application/json'},
            json=registration_data
        )
        
        if response.status_code == 200:
            new_user = response.json()
            print_test_result(
                "Registration Flow", 
                True,
                f"Status: {response.status_code}, User created successfully",
                new_user
            )
            return True
        else:
            print_test_result(
                "Registration Flow", 
                False,
                f"Status: {response.status_code}, Response: {response.text[:200]}"
            )
            return False
    except Exception as e:
        print_test_result("Registration Flow", False, f"Exception: {str(e)}")
        return False

def test_login_simulation(users):
    """Simulate login by checking if user exists (since there's no password auth)"""
    user_found, user_data = test_user_exists(users, TEST_EMAIL)
    
    if user_found:
        # Check if user has proper employee relationship
        has_relationship = test_user_employee_relationship(user_data)
        print_test_result(
            "Login Simulation", 
            has_relationship,
            f"User found and has proper employee relationship: {has_relationship}"
        )
        return has_relationship
    else:
        print_test_result(
            "Login Simulation", 
            False,
            f"User {TEST_EMAIL} not found in database"
        )
        return False
    
    def test_get_ratings(self):
        """Test GET /api/ratings endpoint"""
        try:
            response = requests.get(f"{self.base_url}/ratings")
            if response.status_code == 200:
                ratings = response.json()
                if isinstance(ratings, list):
                    self.log_test("GET Ratings", True, f"Retrieved {len(ratings)} ratings")
                    
                    # If there are ratings, verify structure
                    if ratings:
                        rating = ratings[0]
                        required_fields = ['id', 'evaluator_id', 'evaluated_id', 'ratings_json']
                        missing_fields = [field for field in required_fields if field not in rating]
                        
                        if missing_fields:
                            self.log_test("GET Ratings Structure", False, f"Missing fields: {missing_fields}", rating)
                            return False
                        
                        # Verify ratings_json is valid JSON
                        try:
                            if isinstance(rating['ratings_json'], str):
                                json.loads(rating['ratings_json'])
                            elif not isinstance(rating['ratings_json'], dict):
                                self.log_test("GET Ratings Structure", False, "ratings_json is not valid JSON", rating)
                                return False
                        except json.JSONDecodeError:
                            self.log_test("GET Ratings Structure", False, "ratings_json is not valid JSON", rating)
                            return False
                    
                    return True
                else:
                    self.log_test("GET Ratings", False, "Response is not a list", ratings)
                    return False
            else:
                self.log_test("GET Ratings", False, f"HTTP {response.status_code}: {response.text}")
                return False
        except Exception as e:
            self.log_test("GET Ratings", False, f"Request error: {str(e)}")
            return False
    
    def test_post_rating(self):
        """Test POST /api/ratings endpoint"""
        try:
            # First get users to use real IDs
            users_response = requests.get(f"{self.base_url}/users")
            if users_response.status_code != 200:
                self.log_test("POST Rating", False, "Cannot get users for rating test")
                return False
            
            users = users_response.json()
            if len(users) < 2:
                self.log_test("POST Rating", False, "Need at least 2 users for rating test")
                return False
            
            test_rating = {
                "evaluator_id": users[0]['id'],
                "evaluated_id": users[1]['id'],
                "ratings_json": {
                    "communication": 4,
                    "sales_skills": 5,
                    "customer_service": 4,
                    "teamwork": 5,
                    "overall": 4.5
                },
                "comments": "Excellent performance in sales and teamwork",
                "date": date.today().isoformat()
            }
            
            response = requests.post(f"{self.base_url}/ratings", json=test_rating)
            if response.status_code == 200:
                created_rating = response.json()
                
                # Verify the created rating has all required fields
                required_fields = ['id', 'evaluator_id', 'evaluated_id', 'ratings_json']
                missing_fields = [field for field in required_fields if field not in created_rating]
                
                if missing_fields:
                    self.log_test("POST Rating", False, f"Missing fields in response: {missing_fields}", created_rating)
                    return False
                
                # Store ID for potential cleanup
                self.created_ids.append(('ratings', created_rating['id']))
                
                self.log_test("POST Rating", True, "Rating created successfully", created_rating)
                return True
            else:
                self.log_test("POST Rating", False, f"HTTP {response.status_code}: {response.text}")
                return False
        except Exception as e:
            self.log_test("POST Rating", False, f"Request error: {str(e)}")
            return False
    
    def test_get_follow_ups(self):
        """Test GET /api/follow-ups endpoint"""
        try:
            response = requests.get(f"{self.base_url}/follow-ups")
            if response.status_code == 200:
                follow_ups = response.json()
                if isinstance(follow_ups, list):
                    self.log_test("GET Follow-ups", True, f"Retrieved {len(follow_ups)} follow-ups")
                    
                    # If there are follow-ups, verify structure
                    if follow_ups:
                        follow_up = follow_ups[0]
                        required_fields = ['id', 'user_id', 'data_json']
                        missing_fields = [field for field in required_fields if field not in follow_up]
                        
                        if missing_fields:
                            self.log_test("GET Follow-ups Structure", False, f"Missing fields: {missing_fields}", follow_up)
                            return False
                        
                        # Verify data_json is valid JSON
                        try:
                            if isinstance(follow_up['data_json'], str):
                                json.loads(follow_up['data_json'])
                            elif not isinstance(follow_up['data_json'], dict):
                                self.log_test("GET Follow-ups Structure", False, "data_json is not valid JSON", follow_up)
                                return False
                        except json.JSONDecodeError:
                            self.log_test("GET Follow-ups Structure", False, "data_json is not valid JSON", follow_up)
                            return False
                    
                    return True
                else:
                    self.log_test("GET Follow-ups", False, "Response is not a list", follow_ups)
                    return False
            else:
                self.log_test("GET Follow-ups", False, f"HTTP {response.status_code}: {response.text}")
                return False
        except Exception as e:
            self.log_test("GET Follow-ups", False, f"Request error: {str(e)}")
            return False
    
    def test_post_follow_up(self):
        """Test POST /api/follow-ups endpoint"""
        try:
            # First get users to use real ID
            users_response = requests.get(f"{self.base_url}/users")
            if users_response.status_code != 200:
                self.log_test("POST Follow-up", False, "Cannot get users for follow-up test")
                return False
            
            users = users_response.json()
            if not users:
                self.log_test("POST Follow-up", False, "No users available for follow-up test")
                return False
            
            test_follow_up = {
                "user_id": users[0]['id'],
                "data_json": {
                    "membership_type": "Premium",
                    "contact_date": date.today().isoformat(),
                    "status": "pending",
                    "notes": "Customer interested in premium package",
                    "next_contact": "2024-02-15",
                    "priority": "high"
                }
            }
            
            response = requests.post(f"{self.base_url}/follow-ups", json=test_follow_up)
            if response.status_code == 200:
                created_follow_up = response.json()
                
                # Verify the created follow-up has all required fields
                required_fields = ['id', 'user_id', 'data_json']
                missing_fields = [field for field in required_fields if field not in created_follow_up]
                
                if missing_fields:
                    self.log_test("POST Follow-up", False, f"Missing fields in response: {missing_fields}", created_follow_up)
                    return False
                
                # Store ID for potential cleanup
                self.created_ids.append(('follow_ups', created_follow_up['id']))
                
                self.log_test("POST Follow-up", True, "Follow-up created successfully", created_follow_up)
                return True
            else:
                self.log_test("POST Follow-up", False, f"HTTP {response.status_code}: {response.text}")
                return False
        except Exception as e:
            self.log_test("POST Follow-up", False, f"Request error: {str(e)}")
            return False
    
    def test_database_connection(self):
        """Test if Supabase database connection is working"""
        try:
            # Test by trying to get users - this will test the connection
            response = requests.get(f"{self.base_url}/users")
            if response.status_code == 200:
                self.log_test("Database Connection", True, "Supabase connection working")
                return True
            else:
                self.log_test("Database Connection", False, f"Connection failed: HTTP {response.status_code}")
                return False
        except Exception as e:
            self.log_test("Database Connection", False, f"Connection error: {str(e)}")
            return False
    
    def run_all_tests(self):
        """Run all backend API tests"""
        print("🚀 Starting Club Vacacional Backend API Tests")
        print("=" * 60)
        
        tests = [
            ("Database Connection", self.test_database_connection),
            ("API Root", self.test_api_root),
            ("GET Users", self.test_get_users),
            ("POST User", self.test_post_user),
            ("GET Ratings", self.test_get_ratings),
            ("POST Rating", self.test_post_rating),
            ("GET Follow-ups", self.test_get_follow_ups),
            ("POST Follow-up", self.test_post_follow_up),
        ]
        
        passed = 0
        total = len(tests)
        
        for test_name, test_func in tests:
            print(f"\n🧪 Running: {test_name}")
            try:
                if test_func():
                    passed += 1
            except Exception as e:
                self.log_test(test_name, False, f"Test execution error: {str(e)}")
        
        print("\n" + "=" * 60)
        print(f"📊 Test Results: {passed}/{total} tests passed")
        
        if passed == total:
            print("🎉 All tests passed! Backend API is working correctly.")
            return True
        else:
            print(f"⚠️  {total - passed} tests failed. Check the details above.")
            return False
    
    def print_summary(self):
        """Print a summary of all test results"""
        print("\n📋 Detailed Test Summary:")
        print("-" * 60)
        
        for result in self.test_results:
            status = "✅" if result['success'] else "❌"
            print(f"{status} {result['test']}: {result['message']}")
        
        failed_tests = [r for r in self.test_results if not r['success']]
        if failed_tests:
            print(f"\n🔍 Failed Tests Details:")
            for test in failed_tests:
                print(f"  • {test['test']}: {test['message']}")

def main():
    """Main test execution"""
    tester = ClubVacacionalAPITester()
    
    try:
        success = tester.run_all_tests()
        tester.print_summary()
        
        # Exit with appropriate code
        sys.exit(0 if success else 1)
        
    except KeyboardInterrupt:
        print("\n⏹️  Tests interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"\n💥 Unexpected error: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    main()