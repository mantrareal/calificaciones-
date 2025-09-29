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
    
def test_database_integrity():
    """Test overall database integrity"""
    print("=" * 60)
    print("CLUB VACACIONAL BACKEND TESTING")
    print("=" * 60)
    print(f"Testing against: {BASE_URL}")
    print(f"Test user: {TEST_EMAIL}")
    print(f"Expected employee: {EXPECTED_EMPLOYEE_NAME}")
    print(f"Expected employee count: {EXPECTED_EMPLOYEE_COUNT}")
    print("=" * 60)
    print()
    
    # Test API endpoints
    api_working = test_api_root()
    
    # Test users endpoint
    users = test_get_users()
    
    # Test available employees endpoint
    employees, alejandro_found, alejandro_data = test_get_available_employees()
    
    # Test if prueba@test.com user exists
    user_found, user_data = test_user_exists(users, TEST_EMAIL)
    
    # Test user-employee relationship
    if user_found:
        relationship_ok = test_user_employee_relationship(user_data)
    else:
        relationship_ok = False
    
    # Test registration flow
    registration_ok = test_registration_flow(employees, alejandro_data)
    
    # Test login simulation
    login_ok = test_login_simulation(users)
    
    # Summary
    print("=" * 60)
    print("TEST SUMMARY")
    print("=" * 60)
    
    issues_found = []
    
    if not api_working:
        issues_found.append("API root endpoint not working properly")
    
    if len(employees) != EXPECTED_EMPLOYEE_COUNT:
        issues_found.append(f"Available employees count mismatch: found {len(employees)}, expected {EXPECTED_EMPLOYEE_COUNT}")
    
    if not alejandro_found:
        issues_found.append(f"Employee {EXPECTED_EMPLOYEE_NAME} not found in available_employees table")
    
    if not user_found:
        issues_found.append(f"Test user {TEST_EMAIL} not found in users table")
    
    if user_found and not relationship_ok:
        issues_found.append(f"User {TEST_EMAIL} exists but not properly linked to employee {EXPECTED_EMPLOYEE_NAME}")
    
    if not registration_ok:
        issues_found.append("Registration flow not working properly")
    
    if not login_ok:
        issues_found.append(f"Login with {TEST_EMAIL} not working properly")
    
    if issues_found:
        print("❌ CRITICAL ISSUES FOUND:")
        for i, issue in enumerate(issues_found, 1):
            print(f"   {i}. {issue}")
    else:
        print("✅ ALL TESTS PASSED - No critical issues found")
    
    print()
    print("DETAILED FINDINGS:")
    print(f"   • API endpoints working: {api_working}")
    print(f"   • Users in database: {len(users)}")
    print(f"   • Available employees: {len(employees)}")
    print(f"   • Test user exists: {user_found}")
    print(f"   • Employee relationship OK: {relationship_ok}")
    print(f"   • Registration working: {registration_ok}")
    print(f"   • Login simulation OK: {login_ok}")
    
    return len(issues_found) == 0
    
if __name__ == "__main__":
    test_database_integrity()