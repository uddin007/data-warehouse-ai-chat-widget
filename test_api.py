#!/usr/bin/env python3
"""
Test script for Genie FastAPI service
"""
import requests
import json

# Base URL - change to your deployed URL or localhost
BASE_URL = "http://localhost:8000"

def test_health():
    """Test health check endpoint"""
    print("Testing health endpoint...")
    response = requests.get(f"{BASE_URL}/health")
    print(f"Status: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2)}")
    print()

def test_query(question: str, user_id: str = "test-user"):
    """Test query endpoint"""
    print(f"Testing query: {question}")
    
    payload = {
        "user_id": user_id,
        "question": question,
        "max_wait": 120
    }
    
    response = requests.post(
        f"{BASE_URL}/genie/query",
        json=payload,
        headers={"Content-Type": "application/json"}
    )
    
    print(f"Status: {response.status_code}")
    
    if response.status_code == 200:
        data = response.json()
        print(f"Session ID: {data['session_id']}")
        print(f"Status: {data['status']}")
        print(f"Answer: {data['answer_text'][:200]}...")
        
        if data['sql']:
            print(f"SQL: {data['sql'][:100]}...")
        
        if data['rows']:
            print(f"Rows returned: {data['row_count']}")
            print(f"Columns: {data['columns']}")
    else:
        print(f"Error: {response.text}")
    
    print()
    return response.json() if response.status_code == 200 else None

if __name__ == "__main__":
    # Test health
    test_health()
    
    # Test a sample query
    test_query("What are the total sales by region?")
    
    # Test follow-up (uses session)
    # test_query("Show me the top 5", user_id="test-user")
