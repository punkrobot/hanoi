def solve_hanoi(n, source, destination, auxiliary):
    if n == 1:
        return [{'description': f'Move disk {n} from {source} to {destination}', 'disk': n, 'from': source, 'to': destination}]
    
    moves = []
    moves.extend(solve_hanoi(n-1, source, auxiliary, destination))
    moves.append({'description': f'Move disk {n} from {source} to {destination}', 'disk': n, 'from': source, 'to': destination})
    moves.extend(solve_hanoi(n-1, auxiliary, destination, source))
    
    return moves