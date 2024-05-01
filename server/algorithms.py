import networkx as nx
from networkx.algorithms.shortest_paths.astar import astar_path, astar_path_length
from math import log2


def GetPathToPoint(graph, position, goal, enemys, friends):
    """
    return the better path to the goal
    """

    def ManhatanDistance(from_pos, to_pos):
        x0, y0 = from_pos
        x1, y1 = to_pos

        return abs(x1 - x0) + abs(y1 - y0)

    def ParseNode(node):
        return int(node.split(",")[0]), int(node.split(",")[0])

    def Heuristic(node0, node1):
        coords0 = node0.split(",")
        coords1 = node1.split(",")

        coords0 = ParseNode(node0)
        coords1 = ParseNode(node1)

        manhatan_distance_average = 0
        # for friend in friends:
        #     manhatan_distance_average += ManhatanDistance(
        #         coords0, friend
        #     ) + ManhatanDistance(coords1, friend)
        #     pass

        enemy_distance_average = 0
        for enemy in enemys:
            enemy_distance_average += ManhatanDistance(
                coords0, enemy
            ) + ManhatanDistance(coords1, enemy)
            pass

        return (
            ManhatanDistance(coords0, coords1)
            + 10**4 / log2(enemy_distance_average / (len(enemys) + 1) + 2)
            - manhatan_distance_average / (len(friends) + 1)
        )

    new_goal = None
    new_position = None

    if not position in graph.nodes:

        new_position = list(graph.nodes)[0]
        distance = ManhatanDistance(ParseNode(new_position), ParseNode(position))
        for node in graph.nodes:
            if node == position:
                continue
            d = ManhatanDistance(ParseNode(node), ParseNode(position))
            if d < distance:
                distance = d
                new_position = node
                pass
            pass
        pass

    if not goal in graph.nodes:

        new_goal = list(graph.nodes)[0]
        distance = Heuristic(new_goal, goal)
        for node in graph.nodes:
            if node == position:
                continue
            d = Heuristic(node, goal)
            if d < distance:
                distance = d
                new_goal = node
                pass
            pass
        pass

    if not new_goal == None:
        goal = new_goal
        pass

    if not new_position == None:
        position = new_position
        pass

    return list(astar_path(graph, position, goal, heuristic=Heuristic))
