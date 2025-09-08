from flask import Flask, jsonify
from flask_cors import CORS
from hanoi_service import solve_hanoi

app = Flask(__name__)
CORS(app)

@app.route('/api/hanoi/<int:n>', methods=['GET'])
def get_hanoi_solution(n):
    if n < 1 or n > 12:
        return jsonify({'error': 'Number of disks must be between 1 and 12'}), 400
    
    moves = solve_hanoi(n, 'A', 'C', 'B')
    
    return jsonify({
        'disks': n,
        'moves_count': len(moves),
        'moves': moves
    })

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8080)